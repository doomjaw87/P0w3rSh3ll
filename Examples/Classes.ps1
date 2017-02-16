<#################
| USING CLASSES! | 
##################

Beginning in PowerShell 5, there is a new keyword called "class". It creates new classes for you.
You can use classes as a blue print for new objects. Here is code that defines the blueprint for a 
new class called "Info", with a number of properties.

#>

#requires -Version 5.0
class Info
{
    $Name
    $Computer
    $Date
}

# Generic syntax to create a new object instance
$infoObj = New-Object -TypeName Info

# Alternate syntax, PowerShell 5+
$infoObj = [Info]::new()

$infoObj

$infoObj.Name = $env:COMPUTERNAME
$infoObj.Computer = $env:COMPUTERNAME
$infoObj.Date = Get-Date

$infoObj
$infoObj.GetType().Name


# You can use New-Object to create as many new instances of this class. Each instance
# represents a new object of type "Info" with three properties.

# This is just a very simple (yet useful) example of how to use classes to produce objects. If you
# just want to store different pieces of information in a new object, you could as well use
# [PSCustomObject] which was introduced in PowerShell 3:

# requires -Version 3.0
$infoObj = [PSCustomObject]@{
    Name = $env:COMPUTERNAME
    Computer = $env:COMPUTERNAME
    Date = Get-Date
}
$infoObj
$infoObj.GetType().Name

# This approach does not use a blueprint (class) and instead creates individual new objects based
# on a hash table.

# So the type of the produced object is always "PSCustomObject" whereas in the previous example,
# the object type was defined by the class name


<###########################
| INITIALIZING PROPERTIES! |
############################

Class properties can be assigned a mandatory type and a default value. When you instantiate an 
object from a class, the properties are pre-populated and accept only the data type specified

#>
#requires -Version 5.0
class Info2
{
    # Strongly typed properties with default values
    [String]$Name = $env:USERNAME
    [String]$Computer = $env:COMPUTERNAME
    [DateTime]$Date = (Get-Date)
}

# create instance
$infoObj2 = [Info2]::New()

# view default (initial) values
$infoObj2

# change value
$infoObj2.Name = 'test'



<##################
| ADDING METHODS! |
###################

One of the great advantages of classes VS. [PSCustomObject] is their ability to also define
methods (commands). Here is an example that implements a stop watch. The stop watch can be
used to measure how long code takes to execute:

#>
#requires -Version 5.0
class StopWatch
{
    # Property is marked "hidden" because it is used internally only
    # it is not shown by IntelliSense
    hidden [DateTime]$LastDate = (Get-Date)

    [int] TimeElapsed()
    {
        # Get current date
        $now = Get-Date
        # and subtract last date, report back milliseconds
        $milliseconds = ($now - $this.LastDate).TotalMilliseconds
        # use $this to access internal properties and methods
        # update the last date so that it now is the current date
        $this.LastDate = $now
        # use "return" to define the return value
        return $milliseconds
    }

    Reset()
    {
        $this.LastDate = Get-Date
    }
}

# And this is how you would use the new stop watch:

# Create instance
$stopWatch = [StopWatch]::New()

$stopWatch.TimeElapsed()

Start-Sleep -Seconds 2
$stopWatch.TimeElapsed()

$a = Get-Service
$stopWatch.TimeElapsed()



<###############
| OVERLOADING! |
################

Methods in classes can be overloaded: you can define multiple methods with the same name but
different parameters. This works similar to parameter sets in cmdlets. Have a look:

#>

#requires -Version 5.0
class StopWatch3
{
    # property is marked "hidden" because it is used internally only
    # it is not shown by IntelliSense
    hidden [DateTime]$LastDate = (Get-Date)

    # when no parameter is specified, do not emit verbose info
    [int] TimeElapsed()
    {
        return $this.TimeElapsedInternal($false)
    }

    # user can decide whether to emit verbose info or not
    [int] TimeElapsed([bool]$Verbose)
    {
        return $this.TimeElapsedInternal($Verbose)
    }

    # this method is called by all public methods
    hidden [int] TimeElapsedInternal([bool]$Verbose)
    {
        # Get current date
        $now = Get-Date
        # and subtract last date, report back milliseconds
        $milliseconds = ($now - $this.LastDate).TotalMilliseconds
        # use $this to access internal properties and methods
        # update the last date so that it now is the current date
        $this.LastDate = $now
        # output verbose information if requested
        if ($Verbose)
        {
            $VerbosePreference = 'Continue'
            'Last step took {0} ms.' -f $milliseconds | Write-Verbose
        }
        # use "return" to define the return value
        return $milliseconds
    }

    Reset()
    {
        $this.LastDate = Get-Date
    }
}

# Create Instance
$stopwatch = [StopWatch3]::new()

# do not output verbose info
$stopWatch.TimeElapsed()

Start-Sleep -Seconds 2
# output verbose info
$stopWatch.TimeElapsed($true)

$a = Get-Service
# output verbose info
$stopWatch.TimeElapsed($true)





<##################
| STATIC MEMBERS! |
###################

Classes can define so-called "static" members. Static members (properties and methods) can be
invoked by the class itself and do not require an object instance.

#>

#requires -Version 5.0
class TextToSpeech
{
    # store the initialized synthesizer here
    hidden static $synthesizer

    # static constructor, gets call whenever the type is initialized
    static TextToSpeech()
    {
        Add-Type -AssemblyName System.Speech
        [TextToSpeech]::synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    }

    # convert text to speech
    static Speak([string] $Text)
    {
        [TextToSpeech]::synthesizer.Speak($text)
    }
}

# This class "TextToSpeech" encapsulates all that is needed to convert text to speech. It uses a
# static constructor (which executes when the type is defined) and a static method, so there is no
# need to instantiate an object. You can use "Speak" immediately:
[TextToSpeech]::Speak('Hello world!')

# If you wanted to do the same without "static", the class would look very similar. You would just
# need to remove all "static" keywords, and access class properties via $this instead of the type:
Class TextToSpeechNoStatic
{
    # store the initialized synthesizer here
    hidden $synthesizer
    
    # static constructor, gets called whenever the type is initialized
    TextToSpeechNoStatic()
    {
        Add-Type -AssemblyName System.Speech
        $this.synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    }

    # convert text to speech
    Speak([string]$text)
    {
        $this.synthesizer.speak($text)
    }
}

# The most significant different would be on the user side: the user would now have to instantiate
# an object first:
$speak = [TextToSpeechNoStatic]::new()
$speak.Speak('Hello world!')


# So the thumb of rule is:
# - Use "static" members for functionality that only needs to exist once (so a text to speech
#   converter is a good example of a static class)
# - Use "dynamic" members for functionality that may co-exist in more than one instance (so
#   the user can instantiate as many independent objects as he/she may need)