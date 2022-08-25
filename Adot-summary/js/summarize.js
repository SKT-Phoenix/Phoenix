function summarize_fn(text, deep, target_lang) {
    return new Promise(function (resolve, reject) {
        //-----send text to server and get result-----//
        ssummary_url = "https://20.196.212.210:443/"
        //ssummary_url = "http://127.0.0.1:8000/"

        $.ajax({
            type: 'POST',
            url: ssummary_url,
            data: { 'content': text, 'deep': deep, 'target_lang': target_lang },
            beforeSend: function(){
                console.log("length: " + text.length + 
                                "\ntarget_lang: " + target_lang +
                                "\nbefore:\n" + text);
            },
            success: function(result, status){
                result_text = result['text'];
                console.log("length: " + result_text.length + "\nafter:\n" + result_text);
                resolve(result_text);
            },
            error: function(xhr, status, error){
                if (error == "") error = "server cannot connect";
                console.log(error);
                resolve(error);
            }
        });
    });
}