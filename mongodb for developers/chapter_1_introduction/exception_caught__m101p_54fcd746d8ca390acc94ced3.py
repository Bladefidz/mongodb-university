import sys

try:
    print 5 / 0
except Exception as e:
    print "exception: ", type(e), e

print "but life goes on"

