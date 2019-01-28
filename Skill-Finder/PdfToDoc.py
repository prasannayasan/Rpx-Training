import os
import re
import xlsxwriter
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



def documentToText(filename, filepath):
    if filename[-4:] == ".doc":
        cmd = ['antiword', filepath]
        p = Popen(cmd, stdout=PIPE)
        stdout, stderr = p.communicate()
        return stdout.decode('ascii', 'ignore')

    elif filename[-5:] == ".docx":
        document = opendocx(filepath)
        paratextlist = getdocumenttext(document)
        newparatextlist = []
        for paratext in paratextlist:
            newparatextlist.append(paratext.encode("utf-8"))
        return '\n\n'.join(newparatextlist)
    
    elif filename[-4:] == ".pdf":
        return pdfToTxt(filepath)



fileDirectory = '/home/prasanna/prasanna/demorun'
SkillPath = '/home/prasanna/prasanna/Skill.txt'

list = os.listdir(fileDirectory)
skillReader(SkillPath)

workbook = xlsxwriter.Workbook('SkillSetReader.xlsx')
worksheet = workbook.add_worksheet()

worksheet.write('A1','Resume')
worksheet.write('B1','Skillcount')
worksheet.write('C1','    Skills')
i = 3

for fname in list:
	nfileDirectory = fileDirectory + '/' + fname
	val = documentToText(fname, nfileDirectory)
	newfname = fname[:-4]
	resname = newfname
	newfname = '/home/prasanna/prasanna/Textfiles/' + newfname + '.txt'
	filecreate = open(newfname,'w')
	filecreate.write(val)
	
	skillcount = 0
	skillname = ""
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
		#print(count)
		if count != 0: 
			skillname = skillname + '  ' + skilltest
			skillcount = skillcount + 1
	vala = 'A' + str(i)
	valb = 'B' + str(i)
	valc = 'C' + str(i)
	print(resname , skillcount , skillname)
	worksheet.write(vala,resname)
	worksheet.write(valb,skillcount)
	worksheet.write(valc,skillname)
	i = i+1

workbook.close()
print('SkillSetReader.xlsx file is created')