module App
include("whisper.jl")
using .WhisperGenie
using GenieFramework
@genietools

@app begin
    @in process = false
    @in url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    @out transcription = ""
    @onchange process begin
        # download_audio(url)
        transcription = whisper_transcribe()
    end
end

function ui()
    [
        h2("Youtube video transcriber")
        input("url", :url, style="width:500px")
        button("Transcribe", @click("process = !process"))
        h4("Transcription:")
        p("{{transcription}}")
    ]
end

@page("/", app.jl.html)
Server.up()
end
