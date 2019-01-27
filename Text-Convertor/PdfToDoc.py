import os
import re
from subprocess import Popen, PIPE
from docx import opendocx, getdocumenttext
from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
from pdfminer.converter import TextConverter
from pdfminer.layout import LAParams
from pdfminer.pdfpage import PDFPage
from cStringIO import StringIO

skillset = []
def skillReader(SkillPath):
	skills = open(SkillPath, 'r')
	resume = skills.readlines()
	skills.close()
	for line in resume:
		line = line.strip()
		skillset.append(line)
	#print(skillset)

def pdfToTxt(path):
    rsrcmgr = PDFResourceManager()
    retstr = StringIO()
    codec = 'utf-8'
    laparams = LAParams()
    device = TextConverter(rsrcmgr, retstr, codec=codec, laparams=laparams)
    fp = file(path, 'rb')
    interpreter = PDFPageInterpreter(rsrcmgr, device)
    password = ""
    maxpages = 0
    caching = True
    pagenos=set()
    for page in PDFPage.get_pages(fp, pagenos, maxpages=maxpages, password=password,caching=caching, check_extractable=True):
        interpreter.process_page(page)
    fp.close()
    device.close()
    str = retstr.getvalue()
    retstr.close()
    return str

way = '/home/prasanna/prasanna/demorun'
SkillPath = '/home/prasanna/prasanna/Skill.txt'
list = os.listdir(way)
#print(list)

skillReader(SkillPath)

for fname in list:
	slice = way + '/' + fname
	val = pdfToTxt(slice)
	newfname = fname[:-4]
	resname = newfname
	newfname = '/home/prasanna/prasanna/Textfiles/' + newfname + '.txt'
	filecreate = open(newfname,'w')
	filecreate.write(val)
	
	skillcount = 0
	for skilltest in skillset:
		skilltest = skilltest.lower()
		#print(skilltest)
		count = 0
		for test in val.split(' '):
			test = test.lower()	

			test = re.sub(r'[?|.|,|!|:|;|#]',r'',test)

			length = len(skilltest)
			if test.find(skilltest) != -1 and len(test) == length:
				count = count + 1
		print(count)
		if count != 0: 
			skillcount = skillcount + 1		

	print(resname , skillcount)

#print(".txt file created")