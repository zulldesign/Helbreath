using System;

/// <summary>
/// Summary description for FeedItem
/// </summary>
public class FeedItem {
    public FeedItem(string id, string title, string author, string content, DateTimeOffset publishedDate, string photoUrl, string webUrl) {
        Id = id;
        Title = title;
        Author = author;
        HtmlContent = content;
        PublishedDate = publishedDate;
        PhotoUrl = photoUrl;
        WebUrl = webUrl;
    }

    public string Id { get; private set; }
    public string Title { get; private set; }
    public string Author { get; private set; }
    public string HtmlContent { get; private set; }
    public DateTimeOffset PublishedDate { get; private set; }
    public string PhotoUrl { get; private set; }
    public string WebUrl { get; private set; }
}