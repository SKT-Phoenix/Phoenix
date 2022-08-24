import torch
from transformers import PreTrainedTokenizerFast
from transformers import BartForConditionalGeneration




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
            if len(text)%input_size < 600:
                index = len(text)//input_size 
                text = text[:input_size*index]
        
        # text길이 확인    
        print(F"text길이 : {len(text)}")
        
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