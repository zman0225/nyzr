import urllib
import sys
import os

URLs = [
	"https://www.google.com/images/srpr/logo11w.png",
	"http://i.imgur.com/TigwF.jpg",
	"http://conquest.imslp.info/files/imglnks/usimg/e/ea/IMSLP113136-PMLP01646-FChopin_s_Werke_BH_Band1_Title_Pages.pdf",
	"http://i.imgur.com/poKTTTq.jpg",
	"http://upload.wikimedia.org/wikipedia/commons/2/22/Turkish_Van_Cat.jpg",
	"http://www.safehavenrr.org/Images/bunny.jpg",
	"https://developer.apple.com/library/ios/documentation/General/Conceptual/iCloudDesignGuide/iCloudDesignGuide.pdf",
	"http://javanese.imslp.info/files/imglnks/usimg/3/39/IMSLP140684-PMLP02666-Liszt_Franz-3_Etudes_de_Concert_S.144_No.3_Kistner_1655_filter.pdf"
	]

def main(args):

	if len(args) == 1:
		for url in URLs:
			filePath = os.path.join(os.path.expanduser("~/Downloads"), url.split('/')[-1])
			urllib.urlretrieve (url, filePath)
			print '\"' + url + '\" downloaded to \"' + filePath + '\"'
	else:
		if (args[1] == "purge"):
			for url in URLs:
				filePath = os.path.join(os.path.expanduser("~/Downloads"), url.split('/')[-1])
				os.remove(filePath)

if __name__ == "__main__":
	sys.exit(main(sys.argv))