from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):

	@task(1)
	def book(self):
    		self.client.post("/rest/book",  "{'hotelReq': {'hotelId': 123,'hotelArrivalDate': '01/01/2016','hotelNights': 10,'hotelCity': 'GRU' }}", headers={'Content-Type':'application/json'})

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait=5000
    max_wait=9000
