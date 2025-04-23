public with sharing class ChatterPublisher {
    @InvocableMethod(label='Postar no Chatter')
    public static void postToChatter(List<Id> recordIds) {
        for (Id recId : recordIds) {
            FeedItem post = new FeedItem();
            post.ParentId = recId;
            post.Body = '🚀 A oportunidade foi fechada com sucesso! 🎯';
            post.Type = 'TextPost';
            insert post;
        }
    }
}