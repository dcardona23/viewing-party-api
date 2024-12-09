# Viewing Part API - Solo Project

This is the base repo for the Viewing Party Solo Project for Module 3 in Turing's Software Engineering Program. 

## About this Application

Viewing Party is an application that allows users to explore movies and create a Viewing Party Event that invites users and keeps track of a host. Once completed, this application will collect relevant information about movies from an external API, provide CRUD functionality for creating a Viewing Party and restrict its use to only verified users. 

## Setup

1. Fork and clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{drop,create,migrate,seed}`

## Endpoints
### Users Endpoints

1. **GET** /api/v1/users
  - Description:  Retrieves a list of all users
  - Query Parameters: None
2. **GET** /api/v1/users/:id
  - Description:  Retrieves a specific user's profile by Id
  - Query Parameters: None
3. **POST** /api/v1/users
  - Description:  Creates a new user
  - Query Parameters: NA

### Sessions Endpoints
1. **POST** /api/v1/sessions
  - Description:  Creates a new session (log in)
  - Query Parameters: NA

### Movies Endpoints
1. **GET** /api/v1/movies
- Description:  Retrieves a list of movies
- Query Parameters: Optional parameters include:
  - query: Search term for movies
  - sort_by_rating: Boolean to sort by rating
2. **GET** /api/v1/movies/:id
  - Description:  Retrieves a specific movie by Id
  - Query Parameters: None

### Viewing Parties Endpoints
1. **POST** /api/v1/viewing_parties
  - Description:  Creates a new viewing party
  - Query Parameters: NA
2. **POST** /api/v1/viewing_parties/:id/attendees
  - Description:  Adds attendees to an existing viewing party
  - Query Parameters: NA