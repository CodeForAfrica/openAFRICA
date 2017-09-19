from ckan.lib.base import render

from ckan.controllers.home import HomeController


class CustomPageController(HomeController):
	"""This controller is used to extend some of the static pages with
	the accompanying URL routing associated with it."""
	def toc(self):
		return render('home/about/toc.html')
	def accessibility(self):
		return render('home/about/accessibility.html')
	def coc(self):
		return render('home/about/coc.html')
	def moderation(self):
		return render('home/about/moderation.html')
	def faq(self):
		return render('home/about/faq.html')
	def privacy(self):
		return render('home/about/privacy.html')
	def contact(self):
		return render('home/about/contact.html')
