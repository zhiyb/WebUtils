# Args: Section Keyword
function getSection
{
	sed "s/>/>\n/g;s/</\n</g" - | stripWhiteSpace | stripEmptyLine | sed -n "/^<\s*$1[\s> ]/{
	: next
		s/$2/&/; t output
		s/<\/\s*$1[\s>]//; t
		N
		b next
	: output
		N
		s/<\/\s*$1[\s>]/&/
		t quit
		b output
	: quit
		p
	}"
}

#Args: Field Keyword
function getFieldArg
{
	fgrep "$1" - | fgrep "$2" | sed -n "/<\s*$1[ >]/p" | getArg "$2"
}

# Args: Keyword
function getArg
{
	sed "s/^.*$1=[\"']//;s/[\"'].*//" - | stripAmp
}

# Args: String Keyword
function getURLArg
{
	echo "$1" | sed "s/^.*$2=//;s/&.*\$//"
}

#Args: Data
function getPostData
{
	eval echo $(echo "$1" | tr -d "\n" | sed "{
		s/<[^>]*[^/]>//g
		s/^[^/]*<postfield\s\+name=\"//
		s/\"\s\+value=\"/=/g
		s/\"\s*\/>\s*<postfield\s\+name=\"/\&/g
		s/\".*\$//
		s/\$\([^\&]*\)/\${\1}/g
		s/\&/AND__SIGN/g
		s/\;/SEMI__SIGN/g
	}") | sed "s/AND__SIGN/\&/g; s/SEMI__SIGN/\;/g"
}

# Args: Data Linkname
function getLinkAddr
{
	getArg "$(echo "$1" | tr -d '\n' | sed "s/<a\s\+/\n<a /g;s/<\/\s*a>/<\/a>\n/g" | egrep "<a .*[\s\"><]$2[\s\"><].*\/a>")" href | stripAmp
}

# Accept input stream
function stripAmp
{
	sed "s/\&amp\;/\&/g" -
}

# Accept input stream
function stripWhiteSpace
{
	sed "s/^\s*//;s/\s*\$//" -
}

# Accept input stream
function stripEmptyLine
{
	sed -n "s/^\s*\$//; t; p" -
}

# Accept input stream
function html2text
{
	sed '	s/\&nbsp;/ /g
		s/\&apos;/'\''/g
		s/\&quot;/\"/g
		s/\&amp;/\&/g
		s/\&lt;/</g
		s/\&gt;/>/g
		s/<br\/>//g
		s/\\\\/\\/g' - | stripWhiteSpace
}

# Args:
function fileName
{
	sed "s/\//／/g;s/\\\\/＼/g" -
}

# Args: From, To
function codec
{
	iconv -f "$1" -t "$2" -c -
}
