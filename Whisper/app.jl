module App
include("whisper.jl")
using .WhisperGenie
using GenieFramework
@genietools

@app begin
    @in process = false
    @in url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    @out transcription = ""
    @in transcribe = false
    @in download = false
    @out transcribing = false
    @out downloading = false
    @onchange transcribe begin
        @info "Transcribing $url"
        transcribing = true
        transcription = WhisperGenie.whisper_transcribe()
        transcribing = false
    end
    @onchange download begin
        @info "Downloading $url"
        downloading = true
        WhisperGenie.download_audio(url)
        downloading = false
    end
end

function ui()
    [
        h2("Youtube video transcriber")
        input("url", :url, style="width:500px")
        # button("Transcribe", @click("process = !process"))
        button("Transcribe", @click("transcribing = true"), loading=:transcribing)
        button("Download", @click("download = !download; downloading=true"), loading=:downloading)
        h4("Transcription:")
        p("{{transcription}}")
    ]
end

@page("/", "app.jl.html")
Server.up()
end
