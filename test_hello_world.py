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
        greeting = self.app.get('/hello')
        self.assertIn('Hello, World!', greeting.data.decode('utf-8'))


    def test_second_status_code(self):
        response = self.app.get('/test')
        self.assertEqual(response.status_code, 200)


    def test_second_greeting_message(self):
        greeting = self.app.get('/test')
        self.assertIn('Welcome to Circleci', greeting.data.decode('utf-8'))
        
    def test_third_status_code(self):
        response = self.app.get('/page3')
        self.assertEqual(response.status_code, 200)


    def test_third_greeting_message(self):
        greeting = self.app.get('/page3')
        self.assertIn('Test page', greeting.data.decode('utf-8'))
        

if __name__ == '__main__':
    unittest.main()
