import '../../shared/models/food_item.dart';

class RefluxData {
  static const String placeholderImage = 'https://placehold.co/400x300/F5F5F0/2D2D2D?text=Jedlo';

  static final List<FoodItem> mockFoods = [
    FoodItem(
      id: '1',
      name: 'Ovsená kaša s banánom a čučoriedkami',
      imageUrl: 'https://placehold.co/400x300/E8F5E9/2D2D2D?text=Ovsena+kasa',
      phValue: 6.5,
      fatLevel: 'low',
      overallAcidity: 'low',
      refluxRisk: 'low',
      category: 'breakfast',
      prepTimeMinutes: 15,
      difficulty: 'easy',
      ingredients: const [
        Ingredient(name: 'Ovsené vločky', phValue: 6.8, fatLevel: 'low', sugarContent: 1.0, fiberContent: 4.0),
        Ingredient(name: 'Banán', phValue: 5.0, fatLevel: 'low', sugarContent: 12.0, fiberContent: 2.6),
        Ingredient(name: 'Čučoriedky', phValue: 3.5, fatLevel: 'low', sugarContent: 10.0, fiberContent: 2.4),
        Ingredient(name: 'Med', phValue: 4.0, fatLevel: 'low', sugarContent: 17.0, fiberContent: 0.0),
        Ingredient(name: 'Mlieko', phValue: 6.7, fatLevel: 'low', sugarContent: 5.0, fiberContent: 0.0),
      ],
      recipeSteps: [
        'Zalejte ovsené vločky horúcim mliekom.',
        'Varte na miernom ohni 5 minút, občas premiešajte.',
        'Nakrájajte banán na kolieska.',
        'Hotovú kašu preložte do misky.',
        'Ozdobte banánom, čučoriedkami a kvapkou medu.',
      ],
      refluxRiskExplanation: 'Ovsená kaša je ideálna pre reflux – vláknina absorbuje žalúdočnú kyselinu.',
    ),
    FoodItem(
      id: '2',
      name: 'Pečené kuracie stehno so zemiakovou kašou',
      imageUrl: 'https://placehold.co/400x300/FFF3E0/2D2D2D?text=Kuracie+stehno',
      phValue: 6.2,
      fatLevel: 'medium',
      overallAcidity: 'low',
      refluxRisk: 'medium',
      category: 'lunch',
      prepTimeMinutes: 55,
      difficulty: 'medium',
      ingredients: const [
        Ingredient(name: 'Kuracie stehno', phValue: 6.0, fatLevel: 'medium', sugarContent: 0.0, fiberContent: 0.0),
        Ingredient(name: 'Zemiaky', phValue: 6.1, fatLevel: 'low', sugarContent: 1.7, fiberContent: 2.2),
        Ingredient(name: 'Maslo', phValue: 6.5, fatLevel: 'high', sugarContent: 0.1, fiberContent: 0.0),
        Ingredient(name: 'Hrášok', phValue: 6.5, fatLevel: 'low', sugarContent: 5.7, fiberContent: 5.1),
        Ingredient(name: 'Soľ', phValue: 7.0, fatLevel: 'low', sugarContent: 0.0, fiberContent: 0.0),
      ],
      recipeSteps: [
        'Kuracie stehná osoľte a opečte na panvici z oboch strán.',
        'Preložte do rúry vyhriatej na 180°C a pečte 35 minút.',
        'Zemiaky uvarite v osolenej vode do mäkka.',
        'Zemiaky roztlačte, pridajte maslo a trochu mlieka.',
        'Hrášok krátko povarte a podávajte s kuracinou a kašou.',
      ],
      refluxRiskExplanation: 'Stredné riziko kvôli obsahu tuku v koži kurčaťa. Odporúčame kožu odstrániť.',
    ),
    FoodItem(
      id: '3',
      name: 'Dusená treska s batátovým pyré',
      imageUrl: 'https://placehold.co/400x300/E3F2FD/2D2D2D?text=Treska',
      phValue: 6.8,
      fatLevel: 'low',
      overallAcidity: 'low',
      refluxRisk: 'low',
      category: 'lunch',
      prepTimeMinutes: 35,
      difficulty: 'medium',
      ingredients: const [
        Ingredient(name: 'Treska', phValue: 6.8, fatLevel: 'low', sugarContent: 0.0, fiberContent: 0.0),
        Ingredient(name: 'Batáty', phValue: 5.6, fatLevel: 'low', sugarContent: 4.2, fiberContent: 3.0),
        Ingredient(name: 'Olivový olej', phValue: 6.0, fatLevel: 'high', sugarContent: 0.0, fiberContent: 0.0),
        Ingredient(name: 'Petržlenová vňať', phValue: 6.0, fatLevel: 'low', sugarContent: 0.0, fiberContent: 3.3),
      ],
      recipeSteps: [
        'Batáty ošúpte a nakrájajte na kúsky.',
        'Varte v osolenej vode 20 minút do mäkka.',
        'Tresku osoľte a jemne duste na panvici s kvapkou olivového oleja.',
        'Batáty roztlačte na pyré s lyžičkou olivového oleja.',
        'Podávajte tresku na batátovom pyré, posypte petržlenovou vňaťou.',
      ],
      refluxRiskExplanation: 'Treska je nízkotučná ryba, batáty sú alkalické – výborná voľba pri refluxe.',
    ),
    FoodItem(
      id: '4',
      name: 'Omeleta z vajec so špenátom',
      imageUrl: 'https://placehold.co/400x300/E8F5E9/2D2D2D?text=Omeleta',
      phValue: 6.5,
      fatLevel: 'low',
      overallAcidity: 'low',
      refluxRisk: 'low',
      category: 'breakfast',
      prepTimeMinutes: 10,
      difficulty: 'easy',
      ingredients: const [
        Ingredient(name: 'Vajcia', phValue: 7.0, fatLevel: 'medium', sugarContent: 0.4, fiberContent: 0.0),
        Ingredient(name: 'Špenát', phValue: 6.4, fatLevel: 'low', sugarContent: 0.4, fiberContent: 2.2),
        Ingredient(name: 'Soľ', phValue: 7.0, fatLevel: 'low', sugarContent: 0.0, fiberContent: 0.0),
        Ingredient(name: 'Olivový olej', phValue: 6.0, fatLevel: 'high', sugarContent: 0.0, fiberContent: 0.0),
      ],
      recipeSteps: [
        'Vajcia vyšľahajte vidličkou s trochou soli.',
        'Na panvicu dajte kvapku olivového oleja.',
        'Vylejte vajíčkovú zmes a pečte na strednom ohni.',
        'Pridajte čerstvý špenát na jednu polovicu.',
        'Preložte omeletu a podávajte.',
      ],
      refluxRiskExplanation: 'Vajcia sú pH neutrálne, špenát je alkalický. Vyhýbajte sa pridávaniu korenín.',
    ),
    FoodItem(
      id: '5',
      name: 'Kuracie rizoto s hráškom a cuketou',
      imageUrl: 'https://placehold.co/400x300/FFF3E0/2D2D2D?text=Rizoto',
      phValue: 6.3,
      fatLevel: 'medium',
      overallAcidity: 'low',
      refluxRisk: 'medium',
      category: 'lunch',
      prepTimeMinutes: 40,
      difficulty: 'medium',
      ingredients: const [
        Ingredient(name: 'Ryža arborio', phValue: 6.0, fatLevel: 'low', sugarContent: 0.1, fiberContent: 0.4),
        Ingredient(name: 'Kuracie prsia', phValue: 6.0, fatLevel: 'low', sugarContent: 0.0, fiberContent: 0.0),
        Ingredient(name: 'Cuketa', phValue: 6.0, fatLevel: 'low', sugarContent: 2.5, fiberContent: 1.0),
        Ingredient(name: 'Hrášok', phValue: 6.5, fatLevel: 'low', sugarContent: 5.7, fiberContent: 5.1),
        Ingredient(name: 'Parmezán', phValue: 5.2, fatLevel: 'high', sugarContent: 0.0, fiberContent: 0.0),
      ],
      recipeSteps: [
        'Kuracie prsia nakrájajte na kúsky a opečte na panvici.',
        'V hrnci rozohrejte trochu oleja a pridajte ryžu.',
        'Postupne prilievajte vývar a miešajte.',
        'Po 15 minútach pridajte nakrájanú cuketu a hrášok.',
        'Na konci pridajte nastrúhaný parmezán a premiešajte.',
      ],
      refluxRiskExplanation: 'Stredné riziko kvôli parmezánu. Množstvo syra obmedzte na minimum.',
    ),
    FoodItem(
      id: '6',
      name: 'Grilovaný losos s ryžou a zeleninou',
      imageUrl: 'https://placehold.co/400x300/E3F2FD/2D2D2D?text=Losos',
      phValue: 6.5,
      fatLevel: 'medium',
      overallAcidity: 'low',
      refluxRisk: 'medium',
      category: 'dinner',
      prepTimeMinutes: 30,
      difficulty: 'medium',
      ingredients: const [
        Ingredient(name: 'Losos', phValue: 6.5, fatLevel: 'medium', sugarContent: 0.0, fiberContent: 0.0),
        Ingredient(name: 'Jazmínová ryža', phValue: 6.0, fatLevel: 'low', sugarContent: 0.1, fiberContent: 0.4),
        Ingredient(name: 'Brokolica', phValue: 6.3, fatLevel: 'low', sugarContent: 1.7, fiberContent: 2.6),
        Ingredient(name: 'Mrkva', phValue: 6.0, fatLevel: 'low', sugarContent: 4.7, fiberContent: 2.8),
      ],
      recipeSteps: [
        'Lososa osoľte a grilujte na panvici 4 minúty z každej strany.',
        'Ryžu varte podľa návodu na obale.',
        'Brokolicu a mrkvu nakrájajte a krátko poduste.',
        'Na tanier položte ryžu, zeleninu a lososa.',
        'Podávajte s kvapkou citrónového oleja (nie šťavy!).',
      ],
      refluxRiskExplanation: 'Losos obsahuje omega-3, ale aj vyšší tuk. Stredné riziko – jedzte menšie porcie.',
    ),
    FoodItem(
      id: '7',
      name: 'Banánové smoothie s ovsom',
      imageUrl: 'https://placehold.co/400x300/E8F5E9/2D2D2D?text=Smoothie',
      phValue: 5.8,
      fatLevel: 'low',
      overallAcidity: 'low',
      refluxRisk: 'low',
      category: 'snack',
      prepTimeMinutes: 5,
      difficulty: 'easy',
      ingredients: const [
        Ingredient(name: 'Banán', phValue: 5.0, fatLevel: 'low', sugarContent: 12.0, fiberContent: 2.6),
        Ingredient(name: 'Ovsené vločky', phValue: 6.8, fatLevel: 'low', sugarContent: 1.0, fiberContent: 4.0),
        Ingredient(name: 'Mandľové mlieko', phValue: 6.5, fatLevel: 'low', sugarContent: 3.0, fiberContent: 0.5),
        Ingredient(name: 'Med', phValue: 4.0, fatLevel: 'low', sugarContent: 17.0, fiberContent: 0.0),
      ],
      recipeSteps: [
        'Banán olúpte a nakrájajte na kúsky.',
        'Vložte do mixéra spolu s ovsenými vločkami.',
        'Pridajte mandľové mlieko a lyžičku medu.',
        'Mixujte 30 sekúnd do hladka.',
        'Podávajte okamžite.',
      ],
      refluxRiskExplanation: 'Banán je prirodzený antacid. Ovos absorbuje kyselinu. Vynikajúca desiata.',
    ),
    FoodItem(
      id: '8',
      name: 'Pečené jablko so škoricou',
      imageUrl: 'https://placehold.co/400x300/FFF3E0/2D2D2D?text=Pecene+jablko',
      phValue: 4.5,
      fatLevel: 'low',
      overallAcidity: 'low',
      refluxRisk: 'low',
      category: 'snack',
      prepTimeMinutes: 25,
      difficulty: 'easy',
      ingredients: const [
        Ingredient(name: 'Jablko', phValue: 3.5, fatLevel: 'low', sugarContent: 10.0, fiberContent: 2.4),
        Ingredient(name: 'Škorica', phValue: 6.0, fatLevel: 'low', sugarContent: 0.0, fiberContent: 0.0),
        Ingredient(name: 'Med', phValue: 4.0, fatLevel: 'low', sugarContent: 17.0, fiberContent: 0.0),
        Ingredient(name: 'Vlašské orechy', phValue: 5.4, fatLevel: 'high', sugarContent: 2.6, fiberContent: 6.7),
      ],
      recipeSteps: [
        'Rúru predhrejte na 180°C.',
        'Jablko umyte a vyrežte jadiernik.',
        'Do stredu vložte med a posypte škoricou.',
        'Pečte 20 minút.',
        'Podávajte teplé, ozdobené drvenými orechmi.',
      ],
      refluxRiskExplanation: 'Pečením sa znižuje kyslosť jabĺk. Škorica pomáha tráveniu.',
    ),
    FoodItem(
      id: '9',
      name: 'Zeleninová polievka s ryžovými rezancami',
      imageUrl: 'https://placehold.co/400x300/E8F5E9/2D2D2D?text=Polievka',
      phValue: 6.4,
      fatLevel: 'low',
      overallAcidity: 'low',
      refluxRisk: 'low',
      category: 'dinner',
      prepTimeMinutes: 30,
      difficulty: 'easy',
      ingredients: const [
        Ingredient(name: 'Mrkva', phValue: 6.0, fatLevel: 'low', sugarContent: 4.7, fiberContent: 2.8),
        Ingredient(name: 'Zeler', phValue: 6.5, fatLevel: 'low', sugarContent: 1.8, fiberContent: 1.6),
        Ingredient(name: 'Petržlen', phValue: 6.0, fatLevel: 'low', sugarContent: 0.0, fiberContent: 3.3),
        Ingredient(name: 'Ryžové rezance', phValue: 6.0, fatLevel: 'low', sugarContent: 0.1, fiberContent: 0.4),
        Ingredient(name: 'Zeleninový vývar', phValue: 6.5, fatLevel: 'low', sugarContent: 1.0, fiberContent: 0.0),
      ],
      recipeSteps: [
        'Zeleninu ošúpte a nakrájajte na kúsky.',
        'Vo veľkom hrnci rozohrejte zeleninový vývar.',
        'Pridajte zeleninu a varte 15 minút.',
        'Pridajte ryžové rezance a varte ďalších 5 minút.',
        'Dochutťte soľou a podávajte teplé.',
      ],
      refluxRiskExplanation: 'Zeleninové polievky sú ideálne pri refluxe. Vyhýbajte sa paradajkovým.',
    ),
    FoodItem(
      id: '10',
      name: 'Toasty s avokádom a vajíčkom',
      imageUrl: 'https://placehold.co/400x300/E8F5E9/2D2D2D?text=Avokado+toast',
      phValue: 6.3,
      fatLevel: 'medium',
      overallAcidity: 'low',
      refluxRisk: 'low',
      category: 'breakfast',
      prepTimeMinutes: 10,
      difficulty: 'easy',
      ingredients: const [
        Ingredient(name: 'Celozrnný chlieb', phValue: 6.0, fatLevel: 'low', sugarContent: 3.0, fiberContent: 6.0),
        Ingredient(name: 'Avokádo', phValue: 6.3, fatLevel: 'high', sugarContent: 0.7, fiberContent: 6.7),
        Ingredient(name: 'Vajce', phValue: 7.0, fatLevel: 'medium', sugarContent: 0.4, fiberContent: 0.0),
        Ingredient(name: 'Soľ', phValue: 7.0, fatLevel: 'low', sugarContent: 0.0, fiberContent: 0.0),
      ],
      recipeSteps: [
        'Chlieb opečte v toastovači.',
        'Avokádo roztlačte vidličkou a rozetrite na toast.',
        'Vajce uvarite na mäkko alebo upečte volské oko.',
        'Položte vajce na avokádový toast.',
        'Dochutťte soľou a podávajte.',
      ],
      refluxRiskExplanation: 'Avokádo je zdravý tuk. Celozrnný chlieb obsahuje vlákninu. Nízke riziko refluxu.',
    ),
    FoodItem(
      id: '11',
      name: 'Kuracie prsia s dusenou zeleninou',
      imageUrl: 'https://placehold.co/400x300/E3F2FD/2D2D2D?text=Kuracie+prsia',
      phValue: 6.5,
      fatLevel: 'low',
      overallAcidity: 'low',
      refluxRisk: 'low',
      category: 'dinner',
      prepTimeMinutes: 35,
      difficulty: 'easy',
      ingredients: const [
        Ingredient(name: 'Kuracie prsia', phValue: 6.0, fatLevel: 'low', sugarContent: 0.0, fiberContent: 0.0),
        Ingredient(name: 'Cuketa', phValue: 6.0, fatLevel: 'low', sugarContent: 2.5, fiberContent: 1.0),
        Ingredient(name: 'Mrkva', phValue: 6.0, fatLevel: 'low', sugarContent: 4.7, fiberContent: 2.8),
        Ingredient(name: 'Brokolica', phValue: 6.3, fatLevel: 'low', sugarContent: 1.7, fiberContent: 2.6),
      ],
      recipeSteps: [
        'Kuracie prsia osoľte a opečte na panvici z oboch strán.',
        'Zeleninu nakrájajte na kúsky.',
        'V hrnci duste zeleninu s trochou vody 15 minút.',
        'Kuracie prsia nakrájajte a pridajte k zelenine.',
        'Podávajte teplé.',
      ],
      refluxRiskExplanation: 'Chudé kuracie prsia s dusenou zeleninou sú ideálny obed pri GERD.',
    ),
    FoodItem(
      id: '12',
      name: 'Jogurtový dezert s granolou',
      imageUrl: 'https://placehold.co/400x300/FFF3E0/2D2D2D?text=Jogurt',
      phValue: 4.5,
      fatLevel: 'low',
      overallAcidity: 'medium',
      refluxRisk: 'low',
      category: 'snack',
      prepTimeMinutes: 5,
      difficulty: 'easy',
      ingredients: const [
        Ingredient(name: 'Grécky jogurt', phValue: 4.5, fatLevel: 'low', sugarContent: 3.6, fiberContent: 0.0),
        Ingredient(name: 'Granola', phValue: 6.0, fatLevel: 'low', sugarContent: 5.0, fiberContent: 3.0),
        Ingredient(name: 'Med', phValue: 4.0, fatLevel: 'low', sugarContent: 17.0, fiberContent: 0.0),
        Ingredient(name: 'Čučoriedky', phValue: 3.5, fatLevel: 'low', sugarContent: 10.0, fiberContent: 2.4),
      ],
      recipeSteps: [
        'Do misky naložte grécky jogurt.',
        'Posypte granolou.',
        'Pridajte čučoriedky.',
        'Pokvapkajte medom.',
        'Podávajte okamžite.',
      ],
      refluxRiskExplanation: 'Nízkotučný jogurt s probiotikami je vhodný pri refluxe. Vyberte si bez príchuťí.',
    ),
  ];

  static List<FoodItem> getBreakfastItems() =>
      mockFoods.where((f) => f.category == 'breakfast').toList();

  static List<FoodItem> getLunchItems() =>
      mockFoods.where((f) => f.category == 'lunch').toList();

  static List<FoodItem> getDinnerItems() =>
      mockFoods.where((f) => f.category == 'dinner').toList();

  static List<FoodItem> getSnackItems() =>
      mockFoods.where((f) => f.category == 'snack').toList();

  static FoodItem? getFoodById(String id) {
    try {
      return mockFoods.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<FoodItem> getRecommendedMeals() {
    // Return one breakfast, one lunch, one dinner
    final breakfast = getBreakfastItems();
    final lunch = getLunchItems();
    final dinner = getDinnerItems();
    return [
      if (breakfast.isNotEmpty) breakfast.first,
      if (lunch.isNotEmpty) lunch.first,
      if (dinner.isNotEmpty) dinner.first,
    ];
  }

  static String categoryLabel(String category) {
    switch (category) {
      case 'breakfast':
        return 'Raňajky';
      case 'lunch':
        return 'Obed';
      case 'dinner':
        return 'Večera';
      case 'snack':
        return 'Desiata';
      default:
        return category;
    }
  }
}

