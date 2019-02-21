import os
import re
import PyPDF2 
#from docx import Document, getdocumenttext
#from cStringIO import StringIO
#from IPython import embed
from django.shortcuts import render
from django.http import HttpResponse

def home(request):
    return render(request, 'index.html', {'what':'Resume Uploader'})
 
def upload(request):
    if request.method == 'POST':
        handle_uploaded_file(request.FILES['file'], str(request.FILES['file']))      
        
        finame = str(request.FILES['file'])
        path = 'upload/'+finame
        nfiname = finame[:-4]
        valwrite = pdfToTxt(path)
        fvalwrite = dataFinder(valwrite)
        nfinamedic = 'upload/'+ nfiname + '.txt'
        filecreate = open(nfinamedic,'w')
        display = nfiname
        for f in fvalwrite:
            display = display + '  -  ' + f 
        filecreate.write(display)  
        
        return render(request, 'upload.html', {'what':'Resume Details', 'display': display})
    return HttpResponse("Failed to update")
    
def handle_uploaded_file(file, filename):
    finame = filename
    if not os.path.exists('upload/'):
        os.mkdir('upload/')
    with open('upload/' + filename, 'wb+') as destination:
        for chunk in file.chunks():
            destination.write(chunk)

def pdfToTxt(path):
    pdfFileObj = open(path, 'rb') 
    pdfReader = PyPDF2.PdfFileReader(pdfFileObj) 
    pages = pdfReader.numPages 
    valwrite =''
    for n in range(pages):
        pageObj = pdfReader.getPage(n) 
        valwrite = valwrite +'\n'+ pageObj.extractText()
    pdfFileObj.close() 
    return valwrite

def dataFinder(valwrite):
    mail = re.findall('\S+@\S+', valwrite)
    phone = re.findall(r'\d{10}', valwrite)
    dob = re.findall('\d\d/\d\d/\d\d\d\d', file)
    fval = mail + phone  + dob
    return fval



'''
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

'''