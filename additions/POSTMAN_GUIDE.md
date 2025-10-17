# Mobile API Postman Guide

This guide explains how to import and use the Postman collection for the mobile app, and documents the key textbook APIs with example requests and responses.

---

## 1) Import the collection into Postman

- Open Postman.
- Click "Import" (top-left).
- Choose "File" and select: `fork collection for mobile app/LMS.postman_collection.json`.
- Click "Import".

Optional but recommended:
- Create an Environment named "Local" with variables:
  - `BASE_URL` = `http://127.0.0.1:8000`
  - `API_PREFIX` = `/api/development`
  - `API_KEY` = `1234` (only if your API requires it)
  - `TOKEN` = `<paste JWT from login>`

In your requests, set headers using variables:
- `Accept: application/json`
- `Authorization: Bearer {{TOKEN}}`
- If needed: `x-api-key: {{API_KEY}}`

---

## 2) Authentication (to get Bearer token)

- Use the Auth > Login request in the collection (or create one):
  - Method: `POST`
  - URL: `{{BASE_URL}}{{API_PREFIX}}/auth/login`
  - Headers: `Accept: application/json`, `x-api-key: {{API_KEY}}` (if enabled)
  - Body (JSON):
    ```json
    { "username": "<email or username>", "password": "<password>" }
    ```
  - Copy the `token` from the response and set `{{TOKEN}}` environment variable.

Note: The exact auth endpoint may vary depending on your auth routes. If your project uses a different login path, update the URL accordingly.

---

## 3) Textbook APIs (for Mobile)

All endpoints are under the development prefix: `{{BASE_URL}}{{API_PREFIX}}/textbook` with `Authorization: Bearer {{TOKEN}}` required.

### 3.1 List textbooks (no chapters)

- Purpose: Return textbook cards/details for the logged-in student. Chapters are NOT included here.
- Method: `GET`
- URL: `{{BASE_URL}}{{API_PREFIX}}/textbook/students`
- Optional Query: `subject_id=<ID>`
- Headers:
  - `Accept: application/json`
  - `Authorization: Bearer {{TOKEN}}`

Response (example):
```json
{
  "status": 1,
  "key": "retrieved",
  "msg": "retrieved",
  "data": {
    "textbooks": [
      {
        "id": 12,
        "title": "Algebra 1",
        "price": "0.00",
        "subject_id": 3,
        "standard_id": 1,
        "standard_name": "Grade 6",
        "description": "Plain text description",
        "image_cover": "http://127.0.0.1:8000/storage/textbooks/covers/cover.png",
        "thumbnail": "http://127.0.0.1:8000/storage/textbooks/thumbnails/thumb.png"
      }
    ]
  }
}
```

Notes:
- `standard_name` is resolved from the `standards` table.
- `image_cover` and `thumbnail` are absolute URLs.
- `description` is HTML-stripped (plain text).

### 3.2 Chapters by textbook

- Purpose: Return chapters (and chapter media) for a specific textbook.
- Method: `GET`
- URL: `{{BASE_URL}}{{API_PREFIX}}/textbook/chapters?textbook_id=<ID>`
- Headers:
  - `Accept: application/json`
  - `Authorization: Bearer {{TOKEN}}`

Response (example):
```json
{
  "status": 1,
  "key": "retrieved",
  "msg": "retrieved",
  "data": {
    "textbook_id": 12,
    "textbook_title": "Algebra 1",
    "textbook_description": "Plain text description of the textbook",
    "image_cover": "http://127.0.0.1:8000/storage/textbooks/covers/cover.png",
    "thumbnail": "http://127.0.0.1:8000/storage/textbooks/thumbnails/thumb.png",
    "chapters": [
      {
        "id": 101,
        "title": "Linear Equations",
        "description": "Chapter intro as plain text",
        "media_count": 2,
        "chapter_media": [
          {
            "id": 1001,
            "download_allowed": true,
            "description": "Media description as plain text",
            "images": [
              "http://127.0.0.1:8000/storage/chapter-media/images/img1.jpg"
            ],
            "pdfs": [
              "http://127.0.0.1:8000/storage/chapter-media/pdfs/doc1.pdf"
            ],
            "videos": [
              "http://127.0.0.1:8000/storage/chapter-media/videos/vid1.mp4",
              "http://127.0.0.1:8000/storage/chapter-media/videos/vid2.mp4"
            ],
            "video_durations": [
              "2m 0s",
              "45s"
            ],
            "has_images": true,
            "has_pdfs": true,
            "has_videos": true
          }
        ]
      }
    ]
  }
}
```

Notes:
- All media URLs (`images`, `pdfs`, `videos`) are absolute URLs (`/storage/...`).
- `video_durations` are human-readable strings aligned with the `videos` array.
- `description` fields are plain text (HTML removed).

### 3.3 Subjects for filters (optional)

- Purpose: List subjects assigned to the student's institution for filtering textbooks.
- Method: `GET`
- URL: `{{BASE_URL}}{{API_PREFIX}}/textbook/subjects`
- Headers:
  - `Accept: application/json`
  - `Authorization: Bearer {{TOKEN}}`

Response (example):
```json
{
  "status": 1,
  "key": "retrieved",
  "msg": "retrieved",
  "data": {
    "subjects": [
      { "id": 3, "title": "Mathematics" },
      { "id": 4, "title": "Science" }
    ]
  }
}
```

---

## 4) Storage and media access (local dev)

- Ensure the storage symlink is created:
  - `php artisan storage:link`
- Confirm files exist in `storage/app/public/...` and are accessible via `/storage/...` URLs.
- In `.env`, set `APP_URL=http://127.0.0.1:8000` and clear config cache if needed:
  - `php artisan config:clear && php artisan cache:clear`

---

## 5) Common headers and errors

- Required headers:
  - `Accept: application/json`
  - `Authorization: Bearer <token>`
  - Optionally `x-api-key: 1234` if API key middleware is enabled.

- Error examples:
  - `401 unauthenticated` → Missing/invalid token.
  - `422 validation_error` → Missing required query/body fields.
  - `404 not_found` → Resource does not exist.

---

## 6) Changelog (highlights)

- studentDashboard now returns only textbooks; chapters moved to a separate endpoint.
- Absolute URLs for media and images.
- All descriptions are HTML-stripped to plain text.
- `standard_name` included with textbooks.
- Human-readable `video_durations` in chapters API.
