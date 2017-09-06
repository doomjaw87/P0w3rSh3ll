BREAK

#########################################################################################
$$
    Get-Process | 
        Sort-Object -Property WorkingSet -Descending |
        Select-Object -First 10
    # $$ = 10
    # Contains the last token in the last line received by the session


#########################################################################################
$?
    Get-ChildItem -Path C:\notReal
    $?
    # Contains the execution status of the last operation. It contains
    # TRUE if the last operation succeeded and FALSE if it failed.


#########################################################################################
$^
    Get-Process |
        Sort-Object -Property WorkingSet -Descending |
        Select-Object -First 10
    # $^ = Get-Process
    # Contains the first token in the last line received by the session


#########################################################################################
$_
    Get-Process |
        %{$_.Name}
    # Same as $PSitem. Contains the current object in the pipeline object.
    # You can use this variable in commands that perform an action on every
    # object or on selected objects in a pipeline


#########################################################################################
$AllNodes
    # This variable is available inside of a DSC configuration document when
    # configuration data has been passed into it by using the -ConfigurationData
    # parameter. For more information about configuration data, see "Separating
    # Configuration and Environment Data" on Microsoft TechNet
    # http://technet.microsoft.com/libraty/dn249925.aspx


#########################################################################################
$Args
    # Contains an array of the undeclared parameters and/or parameter
    # values that are passed to a function, script, or script block.
    # When you create a function, you can declare the parameters by using the
    # param keyword or by adding a comma-separated list of parameters in
    # parenthesis after the function name.

    # In an event action, the $Args variable contains objects that represent
    # the event arguments of the event that is being processed. This variable
    # is populated only within the Action block of an event registration
    # command. The value of this variable can also be found in the SourceArgs
    # property. The value of this variable can also be found in the SourceArgs
    # property of the PSEventArgs object (System.Management.Automation.PSEventArgs)
    # that Get-Event returns.


#########################################################################################
$ConsoleFileName
    # Contains the path of the console file (.psc1) that was most
    # recently used in the session. This variable is populated when
    # you start Windows PowerShell with the PSConsoleFile parameter or
    # when you use the Export-Console cmdlet to export snap-in names to a
    # console file.

    # When you use the Export-Console cmdlet without parameters, it
    # automatically updates the console file that was most recently
    # used in the session. You can use this automatic variable to determine
    # which file will be updated.


#########################################################################################
$Error
    Not-aCommand
    $Error
    # Contains an array of error objects that represent the most
    # recent errors. The most recent error is the first error object in the 
    # array ($Error[0]).

    # To prevent an error from being added to the $Error array, use the
    # ErrorAction common parameter with a value of Ignore. For more 
    # information, see about_CommonParameters
    # http://go.microsoft.com/fwlink/?LinkID=133216


#########################################################################################
$Event
    # Contains a PSEventArgs object that represents the event that is being 
    # processed. This variable is populated only within the Action block of
    # an event registration command, such as Register-ObjectEvent. The value
    # of this variable is the same object that the Get-Event cmdlet returns.
    # Therefore, you can use the properties of the $Event variable, such as
    # $Event.TimeGenerated, in an Action script block


#########################################################################################
$EventArgs
    # Contains an object that represents the first event argument that derives
    # from EventArgs of the event that is being processed. This variable is
    # populated only within the Action block of an event registration command.
    # The value of this variable can also be found in the SourceEventArgs
    # property of the PSEventArgs (System.Management.Automation.PSEventArgs)
    # object that Get-Event returns.


#########################################################################################
$EventSubscriber
    # Contains a PSEventSubscriber object that represents the event subscriber
    # of the event that is being processed. This variable is populated only
    # within the Action block of an event registration command. The value of
    # this variable is the same object that the Get-EventSubscriber cmdlet
    # returns