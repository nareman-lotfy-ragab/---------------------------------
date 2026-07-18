import '../models/article_model.dart';

class ArticleDatasource {
  Future<List<ArticleModel>> fetchArticles() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock data with 3 agricultural articles in Arabic
    final List<Map<String, dynamic>> mockData = [
      {
        'title': 'أهمية الري بالتنقيط في الزراعة الحديثة',
        'description': 'تعرف على فوائد نظام الري بالتنقيط وكيفية تحسين إنتاجية المحاصيل مع توفير المياه.',
        'imageUrl': 'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?q=80&w=1000&auto=format&fit=crop',
        'url': 'https://example.com/article1',
        'date': '2024-05-01',
      },
      {
        'title': 'كيفية مكافحة الآفات الزراعية بطرق طبيعية',
        'description': 'دليل شامل حول استخدام الوسائل الحيوية والطبيعية لحماية محاصيلك من الحشرات والأمراض.',
        'imageUrl': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?q=80&w=1000&auto=format&fit=crop',
        'url': 'https://example.com/article2',
        'date': '2024-04-28',
      },
      {
        'title': 'مستقبل الزراعة الذكية في المنطقة العربية',
        'description': 'استكشف كيف تساهم التقنيات الحديثة والذكاء الاصطناعي في تطوير القطاع الزراعي.',
        'imageUrl': 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=1000&auto=format&fit=crop',
        'url': 'https://example.com/article3',
        'date': '2024-04-25',
      },
    ];

    return mockData.map((json) => ArticleModel.fromJson(json)).toList();
  }
}
