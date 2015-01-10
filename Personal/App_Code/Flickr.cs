using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.Net;
using System.Text;
using System.Web.Helpers;

public static class Flickr {
    private const string FlickrApiBaseUrl = "http://api.flickr.com/services/rest/";

    public static List<FeedItem> GetPhotos(string flickrKey, string userName) {
        // query userId from username
        string userId = Flickr.GetUserIdByUserName(flickrKey, userName);
        if (userId == null) {
            throw new ArgumentException("Invalid user name.", userName);
        }
        
        return Flickr.GetPublicPhotosFromUser(flickrKey, userId);
    }

    public static string GetUserIdByUserName(string apiKey, string userName) {
        var parameters = new NameValueCollection {
            { "method", "flickr.people.findByUsername" },
            { "api_key", apiKey },
            { "username", userName },
            { "format", "json" },
            { "nojsoncallback", "1" }
        };
        Uri uri = PrepareRequest(parameters);

        using (var client = new WebClient()) {
            string content = client.DownloadString(uri);
            dynamic json = Json.Decode(content);
            if ((string)json.stat == "ok") {
                return (string)json.user.nsid;
            }
            else {
                return null;
            }
        };
    }

    public static List<FeedItem> GetPublicPhotosFromUser(string apiKey, string userId, int maxPhotos = 20) {
        maxPhotos = Math.Max(maxPhotos, 0);
        var parameters = new NameValueCollection {
            { "method", "flickr.people.getPublicPhotos" },
            { "api_key", apiKey },
            { "user_id", userId },
            { "format", "json" },
            { "per_page", maxPhotos.ToString()},
            { "extras", "description,date_upload,owner_name,url_t"},
            { "nojsoncallback", "1" }
        };
        Uri uri = PrepareRequest(parameters);

        using (var client = new WebClient()) {
            var result = new List<FeedItem>();
            string content = client.DownloadString(uri);
            dynamic json = Json.Decode(content);
            if ((string)json.stat == "ok" && json.photos != null && json.photos.photo != null) {
                foreach (dynamic photo in json.photos.photo) {
                    var feedItem = new FeedItem(
                        id: (string)photo.id,
                        title: (string)photo.title,
                        author: (string)photo.ownername,
                        content: (string)photo.description._content,
                        publishedDate: ConvertFromUnixTimestamp(long.Parse((string)photo.dateupload)),
                        photoUrl: (string)photo.url_t,
                        webUrl: ConstructPhotoWebPageUrl(userId, photo.id)
                    );
                    result.Add(feedItem);
                }
            }

            return result;
        };
    }

    private static DateTime ConvertFromUnixTimestamp(long timestamp) {
        DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return origin.AddSeconds(timestamp);
    }

    private static string ConstructPhotoWebPageUrl(string userId, string photoId) {
        // see this page for details on how to construct url:
        // http://www.flickr.com/services/api/misc.urls.html
        const string photoWebPageUrlTemplate = "http://www.flickr.com/photos/{0}/{1}";
        return String.Format(
            CultureInfo.InvariantCulture,
            photoWebPageUrlTemplate,
            userId,
            photoId);
    }

    private static Uri PrepareRequest(NameValueCollection collection) {
        var queryBuilder = new StringBuilder();
        foreach (string key in collection.Keys) {
            if (queryBuilder.Length > 0) {
                queryBuilder.Append('&');
            }

            queryBuilder.AppendFormat("{0}={1}", key, collection[key]);
        }

        var uriBuilder = new UriBuilder(FlickrApiBaseUrl) {
            Query = queryBuilder.ToString()
        };

        return uriBuilder.Uri;
    }
}