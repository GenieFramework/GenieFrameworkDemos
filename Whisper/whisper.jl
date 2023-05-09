module WhisperGenie
export download_audio, whisper_transcribe
using Whisper, LibSndFile, FileIO, SampledSignals

function download_audio(video_url)
    isfile("audio.m4a") && `rm audio.m4a` |> run
    isfile("output.wav") && `rm output.wav` |> run
    `yt-dlp --extract-audio --output "audio.m4a" $video_url` |> run
    `ffmpeg -i audio.m4a.opus -acodec pcm_s16le -ar 16000 output.wav` |> run
end

function whisper_transcribe()
    s = load("output.wav")

    # Whisper expects 16kHz sample rate and Float32 data
    sout = SampleBuf(Float32, 16000, round(Int, length(s) * (16000 / samplerate(s))), nchannels(s))
    write(SampleBufSink(sout), SampleBufSource(s))  # Resample

    if nchannels(sout) == 1
        data = sout.data
    elseif nchannels(sout) == 2
        sd = sout.data
        data = [sd[i, 1] + sd[i, 2] for i in 1:size(sd)[1]] #convert stereo to mono
    end

    transcribe("base.en", data)
end

end
