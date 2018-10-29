<##############################################################
# ADDING NEW INCREMENTING NUMBER COLUMN IN A GRID VIEW WINDOW #
###############################################################

Maybe you'd like to add a column with incrementing indices to your objects.
Try this:

#>

$startCount = 0
Get-Service |
    Select-Object -Property @{N='ID#';E={$script:startCount++;$startCount}}, * |
    Out-GridView

# When you run this chunk of code, you get a list of services in a grid view window and the first
# column "ID#" is added with incrementing ID numbers.
# The technique can be used to add abitrary columns. Simply use a hash table with a key N[ame]
# for the column name, and key E[xpression] with the script block that generates the column
# content.