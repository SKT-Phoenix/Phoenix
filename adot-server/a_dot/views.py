from django.shortcuts import render
from django.http import JsonResponse


from .modules.model import *
import time

# initialize converter instance
print("=" * 50)
summa_model = Summarizer_with_KoBart()
print("[INFO] summarizor 초기화 성공")
print("=" * 50, end="\n\n")

#--- Function-based View
def summary(request):
    
    if request.method == 'POST':
        text = request.POST['content']
        deep = True if request.POST['deep'] == 'true' else False
        target_lang = request.POST['target_lang']

        print("요약 start")
        start = time.time()
        text_res = summa_model.generate(text) # 번역
        print("요약 소요시간:", time.time() - start)

        # JSON 객체 생성
        result = {
            'text': text_res,
            'deep': deep,
            'target_lang': target_lang
        }

        # send response as JSON
        return JsonResponse(result)
    

