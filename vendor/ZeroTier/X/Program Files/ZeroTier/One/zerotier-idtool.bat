@ECHO OFF
if [X:\ProgramData\ZeroTier\One\zerotier-one_x64.exe] == [] (
	 -i %*
) else (
	X:\ProgramData\ZeroTier\One\zerotier-one_x64.exe -i %*
)
