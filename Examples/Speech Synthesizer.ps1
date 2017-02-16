BREAK
<######################################
| RECORDING VOICE TO FILE SYNTHESIZER |
#######################################

The built-in Microsoft text to speech engine can save audio to a file. This way, you can auto-
generate WAV files. Here is an example: it creates a new "clickme.wav" file on your desktop, and
when you run the file, you hear spoken text

#>

$path = "$home\Desktop\clickme.wav"
Add-Type -AssemblyName System.Speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.SetOutputToWaveFile($path)
$speak.Speak('Hello I am powershell')
$speak.SetOutputToDefaultAudioDevice()


<#################################
| GET INSTALLED SPEECH LANGUAGES |
#################################>
if (!$speak)
{
    Add-Type -AssemblyName System.Speech
    $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
}
$speak.GetInstalledVoices() |
    Select-Object -ExpandProperty VoiceInfo |
        Select-Object Gender, Name, Culture


<########################################################
| USING ADVANCED SPEECH SYNTHESIZER OPTIONS SYNTHESIZER |
#########################################################

The .NET speech engine accepts more than just plain text. If you use SpeakSsml() instead of
Speak(), you can use XML to switch languages, speak rate, and other parameters within a text.

#>
if (!$speak)
{
    Add-Type -AssemblyName System.Speech
    $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
}
$ssml = '
<speak version="1." xmlns="http://www.w3.org/2001/10/synthesis"
    xml:lang="en-US">
    <voice xml:lang="en-US">
        <prosody rate="1">
            <p>
                I am speaking at rate 1
            </p>
        </prosody>
    </voice>
    <voice xml:lang="en-US">
        <prosody rate="0">
            <p>
                I am speaking at rate 0
            </p>
        </prosody>
    </voice>
</speak>
    
    '
$speak.SpeakSsml($ssml)