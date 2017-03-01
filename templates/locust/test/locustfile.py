from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):

	@task(1)
	def book(self):
    		self.client.post("/rest/book",  "{'flightReq': {'flightNo': 123,'flightDate': '01/01/2016', 'flightPassengers':2, 'flightFrom':'EZE','flightTo': 'GRU' },'hotelReq': {'hotelId': 123,'hotelArrivalDate': '01/01/2016','hotelNights': 10,'hotelCity': 'GRU' }, 'carReq': {'carRentalCo': 'Hertz','carStartDate': '01/01/2016','carType': 'abc','carDays': 3,'carCity': 'GRU'}}", headers={'Content-Type':'application/json'})

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait=5000
    max_wait=9000
