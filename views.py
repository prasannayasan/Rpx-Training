import os
import re
#import doc2text
import PyPDF2 
from subprocess import Popen, PIPE
#from docx import Document, getdocumenttext
#from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
#from pdfminer.converter import TextConverter
#from pdfminer.layout import LAParams
#from pdfminer.pdfpage import PDFPage
#from cStringIO import StringIO
#from IPython import embed

from django.shortcuts import render
from django.http import HttpResponse

def home(request):
    return render(request, 'design.html', {'what':'Resume Uploader'})
 
def upload(request):
    if request.method == 'POST':
        handle_uploaded_file(request.FILES['file'], str(request.FILES['file']))
        return HttpResponse("Successful")
    return HttpResponse("Failed")

finame = ''
def handle_uploaded_file(file, filename):
    finame = filename
    if not os.path.exists('upload/'):
        os.mkdir('upload/')
    
    with open('upload/' + filename, 'wb+') as destination:
        for chunk in file.chunks():
            destination.write(chunk)



fileDirectory = '/upload'
nfileDirectory = fileDirectory + '/' + finame


pdfFileObj = open(nfileDirectory, 'rb')
pdfReader = PyPDF2.PdfFileReader(pdfFileObj) 
pageObj = pdfReader.getPage(0) 
content = pageObj.extractText()
pdfFileObj.close() 


resname = finame[:-4]
fnamedic =  fileDirectory + '/' + resname + '.txt'

mail = re.findall('\S+@\S+', chunk)
print(mail)
phone = re.findall(r'\d{10}', chunk)
valwrite =  resname+ '      ' +mail+ '     ' +phone+ '\n\n\n' +content

filecreate = open(fnamedic,'w')
filecreate.write(valwrite)



'''
def pdfToTxt(path):
    pdftotext {PDF-file} {text-file}

    return text

def documentToText(filename, filepath):
    if filename[-4:] == ".doc":
        fdoc = doc2txt.Document()
        fdoc.read()
        fdoc.process()
        fdoc.extract_text()
        text = doc.get_text() 
        return text

    elif filename[-5:] == ".docx":
        fdocx = os.
        return text
    
    elif filename[-4:] == ".pdf":
        return pdfToTxt(filepath)


fileDirectory = '/upload'
nfileDirectory = fileDirectory + '/' + finame
val = documentToText(finame, nfileDirectory)

resname = finame[:-4]
fnamedic =  fileDirectory + '/' + resname + '.txt'

mail = re.findall('\S+@\S+', val)
print(mail)
phone = re.findall(r'\d{10}', val)
valwrite =  resname+ '      ' +mail+ '     ' +phone

filecreate = open(fnamedic,'w')
filecreate.write(valwrite)

'''