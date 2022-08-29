# Question Generation Model with KorQuAD
___

This model is a fine-tuend version of paust/pko-t5-base on the KorQuAD v1.0 Dataset.

### Train

30% 확률로 input answer 대신 '[MASK]'를 넣어 질문 문장을 생성하도록 학습한다.  
그 결과, input answer 없을 때도 적절히 answer을 찾아 질문을 생성할 수 있다.

### Question Generation without Input Answer

```python
context = """ CONTEXT """"
input_answer = '[MASK]'
        
generated = generate(best_model, input_answer, context)
        
show_result(generated)
```

### References
____
pko-t5-base : https://huggingface.co/paust/pko-t5-base  
KorQuAD v1.0 : https://korquad.github.io/KorQuad%201.0/
