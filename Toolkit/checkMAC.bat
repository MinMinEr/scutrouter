@echo off 
:begin 
set input=%1
echo %input%|findstr "^[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]$">nul||goto fail 
echo %input% ����д��MAC��ַ��ʽ����
exit 0
:fail 
echo (error) %input% ����д��MAC��ַ��ʽ����
exit 1