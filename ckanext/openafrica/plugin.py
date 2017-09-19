import ckan.plugins as plugins
import ckan.plugins.toolkit as toolkit


class OpenAfricaPlugin(plugins.SingletonPlugin):
    '''OpenAfrica templating plugin done in 2015.

    '''
    plugins.implements(plugins.IConfigurer)
    plugins.implements(plugins.IRoutes, inherit=True)
    plugins.implements(plugins.ITemplateHelpers)

    def update_config(self, config):
        toolkit.add_template_directory(config, 'templates')
    
        toolkit.add_public_directory(config, 'public')
        toolkit.add_resource('fanstatic', 'openafrica')

    def before_map(self, map):
        map.connect('/about/terms-and-conditions',
                    controller='ckanext.openafrica.controller:CustomPageController', action='toc')
        map.connect('/about/accessibility',
                    controller='ckanext.openafrica.controller:CustomPageController', action='accessibility')
        map.connect('/about/code-of-conduct',
                    controller='ckanext.openafrica.controller:CustomPageController', action='coc')
        map.connect('/about/moderation-policy',
                    controller='ckanext.openafrica.controller:CustomPageController', action='moderation')
        map.connect('/about/faq',
                    controller='ckanext.openafrica.controller:CustomPageController', action='faq')
        map.connect('/about/privacy',
                    controller='ckanext.openafrica.controller:CustomPageController', action='privacy')
        map.connect('/about/contact-us',
                    controller='ckanext.openafrica.controller:CustomPageController', action='contact')
        map.connect('/about/suggest-a-dataset',
                    controller='ckanext.openafrica.controller:CustomPageController', action='suggest_a_dataset')
        return map

    def get_helpers(self):
        """
        All functions, not starting with __ in the ckanext.openafrica.lib
        module will be loaded and made available as helpers to the
        templates.
        """
        from ckanext.openafrica.lib import helpers
        from inspect import getmembers, isfunction

        helper_dict = {}

        funcs = [o for o in getmembers(helpers, isfunction)]
        return dict([(f[0],f[1],) for f in funcs if not f[0].startswith('__')])
