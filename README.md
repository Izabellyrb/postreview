# Post&Review API

This project is a backend application for managing post creation and rating, where users can rate each post only once. The system automatically calculates the average rating for each post and displays a ranking of the highest-rated posts.

## Features

- **Post rating**: Users can rate posts with scores from 1 to 5, and the average rating is calculated automatically.
- **API for post creation and rating**: Allows for the creation of new posts and the addition of ratings.
- **Post ranking**: Displays the top 5 posts based on the average rating.
- **Recurrent IPs**: Displays a list of IPs that were used by different authors

## Main Technologies Used

- Rails 8.0
- Ruby 3.3.3
- PostgreSQL
- RSpec

## Requirements

- Docker (for easy environment setup)
- Postman/Insomnia (optional): For testing API endpoints

## Installation

1. Clone the repository:
```bash
git clone git@github.com:Izabellyrb/postreview.git
# or git clone https://github.com/Izabellyrb/postreview.git
cd postreview
```

2. Rename the `env_example.txt` file to `.env`
```bash
mv env_example.txt .env
```

1. Fill in the variables in the `.env` with your environment values.

2. Build the Docker containers and start the project:
```bash
docker compose build
docker compose up
```

1. If you want, you can populate the db (≈ 200k posts / ≈ 150k ratings):
```bash
docker exec -it postreview /bin/bash
rails db:seed
```

## Running Tests
To run the tests, execute the following command:

```bash
docker exec -it postreview /bin/bash
bundle exec rspec
```

## API Endpoints

### POST /api/v1/posts
- Creates a new post.
<br>

#### Parameters:
- title: Title of the post.
- body: Content of the post.

#### Request Body:
```bash
{
	"post": {
	"title": "New Post",
	"body": "This is the content of the post."
	},
	"user_login": "your_email@example.com"
}
```
### Success Response [200]:
```bash
{
	"message": {
		"title": "New Post",
		"body": "This is the content of the post.",
		"ip": "111.11.0.1",
		"created_at": "2025-02-18T02:08:35.932Z",
		"author": "your_email@example.com"
		}
}
```

### POST /api/v1/ratings
- Rates a post with a score from 1 to 5.
<br>
#### Parameters:
- rating: The rating score (1 to 5).
- post_id: Id of the post
- user_id: Id of the user
  
#### Request Body:
```bash
{
	"rating":
	{
		"value": 1,
		"post_id": 3,
		"user_id": 2
	}
}
```

### Success Response [200]:
```bash
{
	"message": {
	"average_rating": 2.0
	}
}
```

### GET /api/v1/ratings/ranking
- Displays the top 5 posts with the highest average ratings.
- If there are not enough voted posts to be ranked, it shows the current ranking (top 2, top 3, etc)
<br>

### Success Response [200]:
```bash
{
"post_ranking": [
	{
		"id": 2,
		"title": "The Title",
		"body": "The Content"
	},
	{
		"id": 5,
		"title": "Second Best Title",
		"body": "Second Best Content"
	},
	...
	]
}
```

### GET /api/v1/posts/recurrent_ips
- Displays a list of IPs that were posted by different authors.

### Success Response [200]:
```bash
{
"recurrent_ips": [
		{
		"ip": "333.33.33.3",
		"logins": "example@a.com.br, example@a.com, bla@example.com, error@example.com, your_email@mail.com",
		"id": null
		}
	]
}
```

### Other Expected Responses Format
#### Unprocessable_entity [422] (This occurs when required fields are missing.)
```json
{
	"message": [
	"Title can't be blank",
	"Post must exist",
	"IP must be a valid IPv4 or IPv6 IP address",
	"User - you can only vote once per post"
	]
}
```

#### Internal_server_error [500] (This occurs when an unexpected error or issue rises during processing.)
 ```json
{
		"message": "Something wrong happend. Contact us to report - [Error message]."
}
```

## Decisions and Assumptions
- Post creation: I decided to use an email as login, since the users database only have this field. The request returns only the user login (without id, created_at/updated_at), to avoid providing unecessary data.
- Ranking: The ranking is limited to the top 5 posts with the highest average ratings. But can be changed on PostAnalytics Service.
- Ranking: To ensure that multiple requests do not affect the average calculation, the average calculation was moved inside a transaction.
- Services: Used services to help maintain a clean and organized architecture, allowing reusability and scalability. The controller remains focused on handling HTTP requests and responses.
- Seeds: I chose to populate the database with 200k posts through the already created API requests rather than creating a new bulk insertion endpoint. This decision was made to stay within the test's intended scope and to avoid potential security risks associated with exposing a new endpoint. By using the existing API, I ensure that validation and business logic are properly applied, reflecting real-world usage, even though it takes time to populate the db.
