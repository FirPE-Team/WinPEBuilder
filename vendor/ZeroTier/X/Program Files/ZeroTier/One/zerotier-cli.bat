@ECHO OFF
if [X:\ProgramData\ZeroTier\One\zerotier-one_x64.exe] == [] (
	 -q %*
) else (
	X:\ProgramData\ZeroTier\One\zerotier-one_x64.exe -q %*
)
