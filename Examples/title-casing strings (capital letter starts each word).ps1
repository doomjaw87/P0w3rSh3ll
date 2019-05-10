<########################################################
| TITLE-CASING STRINGS (CAPITAL LETTER STARTS EACH WORD |
#########################################################

All Versions

Polishing raw text is not always trivial, and when you'd like to make sure names or texts are well-
formed, and each word starts with a capital letter, it typically involves much work.

Funny enough, every CultureInfo object has a built-in ToTitleCase() method that does the job for
you. If you convert the raw text to all lowercase before, it also takes care of all uppercase words:

#>

$text = "here is some TEXT that I would like to title-case (all words start with an uppercase letter)"

$textInfo = (Get-Culture).TextInfo
$textInfo.ToTitleCase($text)
$textInfo.ToTitleCase($text.ToLower())

# This method may be especially useful for lists of names.