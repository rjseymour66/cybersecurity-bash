# 1. match floating point

'[0-9]*\.[0-9]*'

# 2. back reference for '314 is = 314'

'([0-9]+).*=.*\1'

# 3. Line that begins with digit, ends with digit, anything in between

'^[0-9].*[0-9]$'

# 4. Grouping to match IP addresses

'10\.0\.0\.(25|134)'

# 5. match hex 0x90 if it occurs more than 3x in a row

`0x90{4,}`