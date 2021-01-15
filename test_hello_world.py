from webserver import hello_world
import unittest

class TestHelloWorld(unittest.TestCase):

    def setUp(self):
        self.app = hello_world.app.test_client()
        self.app.testing = True

    def test_status_code(self):
        response = self.app.get('/hello')
        self.assertEqual(response.status_code, 200)
        
    def test_greeting_message(self):
        greeting = 'Hello, World!'
        self.assertEqual(hello_world.helloIndex(), greeting)


    def test_second_status_code(self):
        response = self.app.get('/test')
        self.assertEqual(response.status_code, 200)


    def test_second_greeting_message(self):
        self.app.get('/test')
        self.assert_template_used('page2.html')
        self.assert_context("Welcome to Circleci")
        

if __name__ == '__main__':
    unittest.main()
