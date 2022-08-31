import torch
from transformers import PreTrainedTokenizerFast
from transformers import BartForConditionalGeneration


from typing import List, Dict
import tqdm.notebook as tq
from tqdm.notebook import tqdm
import json
import pandas as pd
import numpy as np

import torch
from pathlib import Path
from torch.utils.data import Dataset, DataLoader
import pytorch_lightning as pl
from pytorch_lightning.callbacks import ModelCheckpoint
from transformers import (
    AdamW,
    T5ForConditionalGeneration,
    T5TokenizerFast as T5Tokenizer
    )

import itertools

from konlpy.tag import Okt
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer




# 요약 모델
class Summarizer_with_Bart:
    def __init__(self, model_name):
        self.tokenizer = PreTrainedTokenizerFast.from_pretrained(model_name)
        self.model     = BartForConditionalGeneration.from_pretrained(model_name)
        
    def generate(self, text, input_size, deep):
        raise NotImplementedError
    
class Summarizer_with_KoBart(Summarizer_with_Bart):
    def __init__(self):
        super().__init__('gogamza/kobart-summarization')
        
    def generate(self, text, input_size=1024, deep=False):
        
        if len(text)//input_size >= 1:
            if len(text)%input_size < 600:  # 마지막 문장이 600자 이하이면 delete
                index = len(text)//input_size 
                text = text[:input_size*index]
        
        # text길이 확인    
        print(f"after  text길이 : {len(text)}")
        
        result = ""
        
        loop = 1
        if deep == True:
            loop = 0
            size = len(text)
            while size // 100 > 0:
                size =  size // 100
                loop += 1
        
        for _ in range(loop):
            if result:
                text = result
            text = text.replace('\n', ' ')
            raw_input_ids = self.tokenizer.encode(text)

            result = ""
            for i in range(0, len(raw_input_ids), input_size):
                dump = raw_input_ids[i:i+input_size]

                input_ids = [self.tokenizer.bos_token_id] + dump + [self.tokenizer.eos_token_id]
                summary_ids = self.model.generate(torch.tensor([input_ids]),  num_beams=4,  max_length=512,  eos_token_id=1)
                result += self.tokenizer.decode(summary_ids.squeeze().tolist(), skip_special_tokens=True)
        return result





# QnA 모델
pl.seed_everything(42)

MODEL_NAME = 'paust/pko-t5-base'
SOURCE_MAX_TOKEN_LEN = 500
TARGET_MAX_TOKEN_LEN = 80
SEP_TOKEN = '<sep>'

tokenizer = T5Tokenizer.from_pretrained(MODEL_NAME)
tokenizer.add_tokens(SEP_TOKEN)
TOKENIZER_LEN = len(tokenizer)

class QGModel(pl.LightningModule):
    def __init__(self):
        super().__init__()
        self.model = T5ForConditionalGeneration.from_pretrained(MODEL_NAME, return_dict=True)
        self.model.resize_token_embeddings(TOKENIZER_LEN) #resizing after adding new tokens to the tokenizer

    def forward(self, input_ids, attention_mask, labels=None):
        output = self.model(input_ids=input_ids, attention_mask=attention_mask, labels=labels)
        return output.loss, output.logits

    def training_step(self, batch, batch_idx):
        input_ids = batch['input_ids']
        attention_mask = batch['attention_mask']
        labels = batch['labels']
        loss, output = self(input_ids, attention_mask, labels)
        self.log('train_loss', loss, prog_bar=True, logger=True)
        return loss

    def validation_step(self, batch, batch_idx):
        input_ids = batch['input_ids']
        attention_mask = batch['attention_mask']
        labels = batch['labels']
        loss, output = self(input_ids, attention_mask, labels)
        self.log('val_loss', loss, prog_bar=True, logger=True)
        return loss

    def test_step(self, batch, batch_idx):
        input_ids = batch['input_ids']
        attention_mask = batch['attention_mask']
        labels = batch['labels']
        loss, output = self(input_ids, attention_mask, labels)
        self.log('test_loss', loss, prog_bar=True, logger=True)
        return loss
  
    def configure_optimizers(self):
        return AdamW(self.parameters(), lr=LEARNING_RATE)
    
def generate(qgmodel: QGModel, answer: str, context: str) -> str:
    source_encoding = tokenizer(
        '{} {} {}'.format(answer, SEP_TOKEN, context),
        max_length=SOURCE_MAX_TOKEN_LEN,
        padding='max_length',
        truncation=True,
        return_attention_mask=True,
        add_special_tokens=True,
        return_tensors='pt'
    )

    generated_ids = qgmodel.model.generate(
        input_ids=source_encoding['input_ids'],
        attention_mask=source_encoding['attention_mask'],
        num_beams=1,
        max_length=TARGET_MAX_TOKEN_LEN,
        repetition_penalty=1.0,
        length_penalty=1.0,
        early_stopping=True,
        use_cache=True
    )

    preds = {
        tokenizer.decode(generated_id, skip_special_tokens=True, clean_up_tokenization_spaces=True)
        for generated_id in generated_ids
    }

    return ''.join(preds)

checkpoint_path = 'module/best-checkpoint-v2.ckpt'

best_model = QGModel.load_from_checkpoint(checkpoint_path)
best_model.freeze()
best_model.eval()

def show_result(generated: str):
    print('Generated: ', generated)
    
    
    
# keybert 사용시
