import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class PromptService {
  static const String _ingredientsPromptEnKey = 'ingredients_prompt_en';
  static const String _ingredientsPromptFrKey = 'ingredients_prompt_fr';
  static const String _barcodePromptEnKey = 'barcode_prompt_en';
  static const String _barcodePromptFrKey = 'barcode_prompt_fr';

  // Default prompts from existing services
  static const String _defaultIngredientsPromptEn =
      '''I'm sending you an image of food ingredients. Please:

1. Identify all ingredients shown in the image
2. Identify potential allergens present in these ingredients
3. Provide a safety analysis considering the following user's allergies: {userAllergies}
4. Categorize the overall safety as: "green" (safe), "yellow" (caution), or "red" (unsafe)

Format your response as a structured JSON object with these keys:
- summary (string): Brief conversational 2-3 sentence assessment suitable for text-to-speech
- ingredients (string array): All identified ingredients
- allergens (string array): Any allergens found
- safetyStatus (string): "green", "yellow", or "red"''';

  static const String _defaultIngredientsPromptFr =
      '''Je vous envoie une image d'ingrédients alimentaires. Veuillez :

1. Identifier tous les ingrédients présents dans l'image
2. Identifier les allergènes potentiels présents dans ces ingrédients
3. Fournir une analyse de sécurité en tenant compte des allergies suivantes de l'utilisateur : {userAllergies}
4. Catégoriser la sécurité globale comme : "green" (sûr), "yellow" (attention), ou "red" (dangereux)

Formatez votre réponse sous forme d'objet JSON structuré avec ces clés :
- summary (chaîne) : Évaluation brève conversationnelle de 2-3 phrases adaptée à la synthèse vocale
- ingredients (tableau de chaînes) : Tous les ingrédients identifiés
- allergens (tableau de chaînes) : Allergènes trouvés
- safetyStatus (chaîne) : "green", "yellow", ou "red"''';

  static const String _defaultBarcodePromptEn =
      '''You are a helpful assistant specializing in food safety and allergen analysis.
Output only a single JSON object in plain text, with no code fences, no markdown, and no extra fields.
The object must contain exactly these four keys:

1. analysis_summary (string): A conversational 2-3 sentence summary of whether the product is safe for the user, suitable for text-to-speech. Do not repeat the key name in the value. The summary must start directly with the answer, not with "analysis_summary:".
2. suggested_alternatives (array of strings): Safe ingredient alternatives for searching products
3. safety_category (string): "green" (safe), "yellow" (caution), or "red" (unsafe)
4. detected_allergens (array of strings): Any allergens found that conflict with user's allergies

User Allergies: {userAllergies}

Product Information:
- Name: {productName}
- Brand: {productBrand}
- Ingredients: {productIngredients}
- Allergens: {productAllergens}
- Nutrition: {productNutrition}

Respond with only the JSON object, no additional text.''';

  static const String _defaultBarcodePromptFr =
      '''Vous êtes un assistant spécialisé dans l'analyse de la sécurité alimentaire et des allergènes.
Répondez uniquement par un objet JSON en texte brut, sans code, sans markdown, et sans champs supplémentaires.
L'objet doit contenir exactement ces quatre clés:

1. analysis_summary (string): Un résumé conversationnel de 2-3 phrases sur la sécurité du produit pour l'utilisateur, adapté à la synthèse vocale. Ne répétez pas le nom de la clé dans la valeur. Le résumé doit commencer directement par la réponse, pas avec "analysis_summary:".
2. suggested_alternatives (array of strings): Ingrédients alternatifs sûrs pour la recherche de produits
3. safety_category (string): "green" (sûr), "yellow" (attention), ou "red" (dangereux)
4. detected_allergens (array of strings): Tous les allergènes trouvés qui entrent en conflit avec les allergies de l'utilisateur

Allergies de l'utilisateur: {userAllergies}

Informations sur le produit:
- Nom: {productName}
- Marque: {productBrand}
- Ingrédients: {productIngredients}
- Allergènes: {productAllergens}
- Nutrition: {productNutrition}

Répondez uniquement par l'objet JSON, pas de texte supplémentaire.''';

  /// Get ingredients prompt for specified language
  static Future<String> getIngredientsPrompt(String language) async {
    final prefs = await SharedPreferences.getInstance();

    if (language.toLowerCase() == 'fr') {
      return prefs.getString(_ingredientsPromptFrKey) ??
          _defaultIngredientsPromptFr;
    } else {
      return prefs.getString(_ingredientsPromptEnKey) ??
          _defaultIngredientsPromptEn;
    }
  }

  /// Get barcode prompt for specified language
  static Future<String> getBarcodePrompt(String language) async {
    final prefs = await SharedPreferences.getInstance();

    if (language.toLowerCase() == 'fr') {
      return prefs.getString(_barcodePromptFrKey) ?? _defaultBarcodePromptFr;
    } else {
      return prefs.getString(_barcodePromptEnKey) ?? _defaultBarcodePromptEn;
    }
  }

  /// Save ingredients prompt for specified language
  static Future<void> saveIngredientsPrompt(
      String language, String prompt) async {
    final prefs = await SharedPreferences.getInstance();

    if (language.toLowerCase() == 'fr') {
      await prefs.setString(_ingredientsPromptFrKey, prompt);
    } else {
      await prefs.setString(_ingredientsPromptEnKey, prompt);
    }

    log('Saved ingredients prompt for language: $language');
  }

  /// Save barcode prompt for specified language
  static Future<void> saveBarcodePrompt(String language, String prompt) async {
    final prefs = await SharedPreferences.getInstance();

    if (language.toLowerCase() == 'fr') {
      await prefs.setString(_barcodePromptFrKey, prompt);
    } else {
      await prefs.setString(_barcodePromptEnKey, prompt);
    }

    log('Saved barcode prompt for language: $language');
  }

  /// Reset prompts to default for specified language
  static Future<void> resetToDefaults(String language) async {
    final prefs = await SharedPreferences.getInstance();

    if (language.toLowerCase() == 'fr') {
      await prefs.remove(_ingredientsPromptFrKey);
      await prefs.remove(_barcodePromptFrKey);
    } else {
      await prefs.remove(_ingredientsPromptEnKey);
      await prefs.remove(_barcodePromptEnKey);
    }

    log('Reset prompts to defaults for language: $language');
  }
}
