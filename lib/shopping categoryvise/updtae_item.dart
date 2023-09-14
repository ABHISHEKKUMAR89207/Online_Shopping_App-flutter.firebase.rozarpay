import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class updateitems extends StatelessWidget {
  Future<void> addElectronicItem(Map<String, dynamic> electronicItem) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection("AllInOneShopping")
          .doc()
          .set(electronicItem);
    }
  }

  void addSampleData() {
    List<Map<String, dynamic>> sampleData = [
      {
        "name": "Hydrating Face Mask Set",
        "price": 19.99,
        "rating": 4.7,
        "stock": 30.0,
        "shortDescription": "Intense Hydration",
        "description":
            "Revitalize your skin with our Hydrating Face Mask Set. These masks are packed with moisturizing ingredients to restore your skin's natural glow.",
        "comments": [
          "These face masks are a must for keeping my skin hydrated.",
          "I use these masks as a pampering treat. They're so soothing.",
          "My skin feels so refreshed and plump after using these masks."
        ],
        "imagePath": "assets/beuty.jpg"
      },
      {
        "name": "Best-Selling Mystery Novel",
        "price": 12.99,
        "rating": 4.5,
        "stock": 40.0,
        "shortDescription": "Intriguing Thriller",
        "description":
            "Dive into suspense with our Best-Selling Mystery Novel. Follow the twists and turns as you uncover the truth behind a perplexing crime.",
        "comments": [
          "I couldn't put this book down. The plot kept me guessing.",
          "A captivating read that had me on the edge of my seat.",
          "If you love mysteries, this book is a must-read."
        ],
        "imagePath": "assets/book1.jpg"
      },
      {
        "name": "Vintage-Inspired Graphic Tee",
        "price": 24.99,
        "rating": 4.8,
        "stock": 35.0,
        "shortDescription": "Nostalgic Style",
        "description":
            "Add a touch of nostalgia to your wardrobe with our Vintage-Inspired Graphic Tee. This tee features a retro design that captures the essence of past eras.",
        "comments": [
          "I love the vintage vibe of this graphic tee. It's so unique.",
          "The quality of the print is great. It hasn't faded after multiple washes.",
          "This tee is a conversation starter. I get compliments whenever I wear it."
        ],
        "imagePath": "assets/cloth.jpg"
      },
      {
        "name": "Wireless Bluetooth Earbuds",
        "price": 79.99,
        "rating": 4.7,
        "stock": 30.0,
        "shortDescription": "Wireless Convenience",
        "description":
            "Experience wireless freedom with our Bluetooth Earbuds. These earbuds offer high-quality sound and a comfortable fit for your on-the-go lifestyle.",
        "comments": [
          "These Bluetooth earbuds are a game-changer for my daily commute.",
          "The sound quality is impressive, and the battery life is excellent.",
          "I love how comfortable these earbuds are, even during long listening sessions."
        ],
        "imagePath": "assets/shoes2.jpg"
      },
      {
        "name": "Anti-Aging Night Cream",
        "price": 34.99,
        "rating": 4.9,
        "stock": 25.0,
        "shortDescription": "Youthful Renewal",
        "description":
            "Turn back the clock with our Anti-Aging Night Cream. This cream works overnight to reduce fine lines and promote a more youthful complexion.",
        "comments": [
          "This night cream is a holy grail for anti-aging skincare.",
          "I wake up with plumper and smoother skin after using this cream.",
          "A must-have for anyone concerned about aging skin. It's worth the investment."
        ],
        "imagePath": "assets/beuty.jpg"
      },
      {
        "name": "Tailored Fit Dress Shirt",
        "price": 49.99,
        "rating": 4.8,
        "stock": 28.0,
        "shortDescription": "Sophisticated Elegance",
        "description":
            "Achieve a polished look with our Tailored Fit Dress Shirt. This shirt offers a modern fit and is perfect for both formal occasions and professional settings.",
        "comments": [
          "I love the fit and feel of this dress shirt. It's a wardrobe essential.",
          "The quality of the fabric is impressive. It's both comfortable and stylish.",
          "I always reach for this shirt when I want to make a great impression."
        ],
        "imagePath": "assets/cloth2.jpg"
      },
      {
        "name": "Ultra HD Smart TV",
        "price": 599.99,
        "rating": 4.7,
        "stock": 20.0,
        "shortDescription": "Immersive Entertainment",
        "description":
            "Experience stunning visuals with our Ultra HD Smart TV. This TV features advanced technology for a cinematic and immersive entertainment experience.",
        "comments": [
          "The picture quality on this TV is mind-blowing. It's like being at the movies.",
          "I love the smart features that allow me to stream my favorite shows.",
          "Setting up this TV was a breeze, and the results are incredible."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Rose Gold Makeup Brush Set",
        "price": 29.99,
        "rating": 4.6,
        "stock": 35.0,
        "shortDescription": "Elegant Application",
        "description":
            "Elevate your makeup routine with our Rose Gold Makeup Brush Set. These brushes are not only functional but also add a touch of elegance to your vanity.",
        "comments": [
          "These brushes are a game-changer for my makeup application.",
          "The rose gold design is stunning and makes them stand out in my collection.",
          "I'm impressed by the quality and how smoothly these brushes apply makeup."
        ],
        "imagePath": "assets/beuty.jpg"
      },
      {
        "name": "Classic Leather Loafers",
        "price": 89.99,
        "rating": 4.9,
        "stock": 22.0,
        "shortDescription": "Timeless Style",
        "description":
            "Step out in style with our Classic Leather Loafers. These loafers offer a comfortable fit and a timeless design that's perfect for any occasion.",
        "comments": [
          "These loafers are incredibly comfortable and versatile. I wear them everywhere.",
          "The quality of the leather is top-notch. They're built to last.",
          "I've received so many compliments on these shoes. They're a must-have."
        ],
        "imagePath": "assets/shoe1.jpg"
      },
      {
        "name": "Smartphone Case with Card Holder",
        "price": 19.99,
        "rating": 4.6,
        "stock": 18.0,
        "shortDescription": "Convenient Protection",
        "description":
            "Streamline your essentials with our Smartphone Case with Card Holder. This case offers protection for your phone and a convenient slot for your cards.",
        "comments": [
          "I love how I can carry my phone and cards together in one case.",
          "The case is slim yet protective. It's perfect for my needs.",
          "This case has become an everyday essential for me. It's so practical."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Compact Travel Backpack",
        "price": 39.99,
        "rating": 4.7,
        "stock": 20.0,
        "shortDescription": "On-the-Go Convenience",
        "description":
            "Stay organized while traveling with our Compact Travel Backpack. This backpack offers multiple compartments and a sleek design for easy transport.",
        "comments": [
          "I love how much I can fit in this backpack without it being bulky.",
          "The quality and durability of this backpack are impressive.",
          "It's my go-to bag for weekend trips. It's practical and stylish."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Luxury Perfume Set",
        "price": 129.99,
        "rating": 4.8,
        "stock": 15.0,
        "shortDescription": "Elegant Fragrance",
        "description":
            "Indulge in the finest scents with our Luxury Perfume Set. This set features a collection of high-end fragrances that captivate the senses.",
        "comments": [
          "These perfumes are truly luxurious and long-lasting.",
          "I love the variety in this set. It's perfect for special occasions.",
          "A little goes a long way with these fragrances. They're worth the investment."
        ],
        "imagePath": "assets/beuty.jpg"
      },
      {
        "name": "Sci-Fi Adventure Novel",
        "price": 14.99,
        "rating": 4.6,
        "stock": 30.0,
        "shortDescription": "Galactic Journey",
        "description":
            "Embark on a thrilling space adventure with our Sci-Fi Adventure Novel. Join the crew on an epic journey across the cosmos.",
        "comments": [
          "This novel had me hooked from the first chapter. A must-read for sci-fi fans.",
          "The world-building in this book is incredible. It feels like I'm in a different universe.",
          "I couldn't get enough of the characters and their interstellar quests."
        ],
        "imagePath": "assets/book3.jpg"
      },
      {
        "name": "Casual Hooded Sweatshirt",
        "price": 39.99,
        "rating": 4.7,
        "stock": 25.0,
        "shortDescription": "Cozy Comfort",
        "description":
            "Stay warm and cozy with our Casual Hooded Sweatshirt. This sweatshirt offers a relaxed fit and is perfect for casual outings or lounging at home.",
        "comments": [
          "I practically live in this sweatshirt during the colder months. It's so soft.",
          "The hood adds an extra level of comfort. I wear it while working from home.",
          "A classic wardrobe staple that's both stylish and comfortable."
        ],
        "imagePath": "assets/cloth2.jpg"
      },
      {
        "name": "Noise-Canceling Wireless Headphones",
        "price": 149.99,
        "rating": 4.9,
        "stock": 20.0,
        "shortDescription": "Immersive Sound",
        "description":
            "Immerse yourself in music with our Noise-Canceling Wireless Headphones. These headphones deliver high-quality sound and block out unwanted background noise.",
        "comments": [
          "These headphones are a game-changer for my daily commute. The noise cancellation is superb.",
          "The sound quality is exceptional. I'm hearing details in my music that I never noticed before.",
          "I can't imagine traveling without these headphones now. They're worth every penny."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Nourishing Hair Care Bundle",
        "price": 29.99,
        "rating": 4.8,
        "stock": 35.0,
        "shortDescription": "Healthy Locks",
        "description":
            "Treat your hair to our Nourishing Hair Care Bundle. This bundle includes shampoo, conditioner, and hair mask to keep your locks healthy and vibrant.",
        "comments": [
          "These hair care products have transformed my hair. It's so much softer and shinier.",
          "The scent of these products is amazing. I look forward to every wash.",
          "A fantastic value for the quality. My hair has never looked better."
        ],
        "imagePath": "assets/beuty.jpg"
      },
      {
        "name": "Cotton Blend Joggers",
        "price": 34.99,
        "rating": 4.7,
        "stock": 30.0,
        "shortDescription": "Comfortable Style",
        "description":
            "Experience ultimate comfort with our Cotton Blend Joggers. These joggers offer a relaxed fit and are perfect for lounging or running errands.",
        "comments": [
          "I'm living in these joggers. They're so comfortable and versatile.",
          "The fabric is soft and breathable. Perfect for all-day wear.",
          "A great addition to my casual wardrobe. I love the fit and feel."
        ],
        "imagePath": "assets/cloth.jpg"
      },
      {
        "name": "4K Ultra HD Smart Projector",
        "price": 699.99,
        "rating": 4.9,
        "stock": 15.0,
        "shortDescription": "Home Theater Experience",
        "description":
            "Create a cinematic experience at home with our 4K Ultra HD Smart Projector. This projector delivers stunning visuals and is perfect for movie nights.",
        "comments": [
          "I'm blown away by the quality of this projector. It's like having a private movie theater.",
          "Setting up this projector was a breeze, and the picture quality is amazing.",
          "Movie nights have become a regular thing at my place. This projector is a game-changer."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Glowing Highlighter Palette",
        "price": 24.99,
        "rating": 4.8,
        "stock": 28.0,
        "shortDescription": "Radiant Glow",
        "description":
            "Enhance your complexion with our Glowing Highlighter Palette. This palette features a range of shades that create a radiant and luminous glow.",
        "comments": [
          "I can't get enough of these highlighter shades. They give me the perfect glow.",
          "The pigmentation and blendability of these highlighters are impressive.",
          "A must-have for anyone who loves a radiant makeup look."
        ],
        "imagePath": "assets/beuty.jpg"
      },
      {
        "name": "Classic Leather Watch",
        "price": 89.99,
        "rating": 4.7,
        "stock": 22.0,
        "shortDescription": "Timeless Elegance",
        "description":
            "Elevate your wrist with our Classic Leather Watch. This watch features a sophisticated design and a genuine leather strap for a timeless look.",
        "comments": [
          "I'm in love with the simplicity and elegance of this watch. It goes with everything.",
          "The quality of the leather and craftsmanship is evident. A fantastic accessory.",
          "I've received so many compliments on this watch. It's a great addition to my collection."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Organic Herbal Tea Sampler",
        "price": 19.99,
        "rating": 4.6,
        "stock": 18.0,
        "shortDescription": "Soothing Brews",
        "description":
            "Relax with our Organic Herbal Tea Sampler. This sampler includes a variety of herbal blends that provide comfort and warmth with every sip.",
        "comments": [
          "I look forward to winding down with these herbal teas. They're so calming.",
          "The flavors in this sampler are diverse and delicious. A great way to explore new teas.",
          "I've made these herbal teas part of my evening routine. They're a delightful treat."
        ],
        "imagePath": "assets/beuty.jpg"
      },
      {
        "name": "Laptop Cooling Pad",
        "price": 29.99,
        "rating": 4.5,
        "stock": 25.0,
        "shortDescription": "Enhanced Performance",
        "description":
            "Keep your laptop running cool and smooth with our Laptop Cooling Pad. This pad helps prevent overheating during extended use.",
        "comments": [
          "This cooling pad has made a noticeable difference in my laptop's performance.",
          "I love how compact and effective this cooling pad is. My laptop stays much cooler now.",
          "A must-have accessory for anyone who uses their laptop for hours. It's a game-changer."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Volumizing Mascara",
        "price": 12.99,
        "rating": 4.7,
        "stock": 30.0,
        "shortDescription": "Dramatic Lashes",
        "description":
            "Achieve bold and voluminous lashes with our Volumizing Mascara. This mascara adds depth and drama to your eye makeup look.",
        "comments": [
          "This mascara truly delivers on volume. My lashes look incredible.",
          "I love how this mascara lifts and separates my lashes. No clumps!",
          "A great drugstore option that rivals high-end mascaras. I'm impressed."
        ],
        "imagePath": "assets/beuty.jpg"
      },
      {
        "name": "Business Laptop Briefcase",
        "price": 59.99,
        "rating": 4.8,
        "stock": 22.0,
        "shortDescription": "Professional Style",
        "description":
            "Carry your essentials in style with our Business Laptop Briefcase. This briefcase offers organization and a sleek design for the modern professional.",
        "comments": [
          "This briefcase is perfect for work. It holds all my essentials and looks professional.",
          "The quality of the materials and construction is top-notch. It's durable and stylish.",
          "I've received compliments on this briefcase from colleagues. It's a great investment."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Classic Aviator Sunglasses",
        "price": 39.99,
        "rating": 4.6,
        "stock": 28.0,
        "shortDescription": "Timeless Eyewear",
        "description":
            "Stay stylish and protected with our Classic Aviator Sunglasses. These sunglasses feature a timeless design that complements any outfit.",
        "comments": [
          "These aviator sunglasses are my go-to for a chic and classic look.",
          "The UV protection is excellent, and the lenses are clear and comfortable.",
          "I'm impressed by the quality of these sunglasses. They're a must-have accessory."
        ],
        "imagePath": "assets/cloth.jpg"
      },
      {
        "name": "High-Performance Gaming Mouse",
        "price": 49.99,
        "rating": 4.9,
        "stock": 20.0,
        "shortDescription": "Precision Gaming",
        "description":
            "Elevate your gaming experience with our High-Performance Gaming Mouse. This mouse offers precise control and customizable features.",
        "comments": [
          "This gaming mouse is a game-changer for my gaming sessions. It's so responsive.",
          "The ergonomic design of this mouse keeps me comfortable during long gaming sessions.",
          "I love the customizable buttons and the DPI options. It's perfect for different games."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Silk Sleep Mask",
        "price": 14.99,
        "rating": 4.7,
        "stock": 25.0,
        "shortDescription": "Luxurious Sleep",
        "description":
            "Indulge in a good night's sleep with our Silk Sleep Mask. This mask provides a gentle and comfortable barrier to light for restful sleep.",
        "comments": [
          "This silk sleep mask is a must-have for getting quality sleep. It's so soft and comfortable.",
          "The adjustable strap ensures a perfect fit. I wake up feeling refreshed.",
          "A luxurious addition to my bedtime routine. It's made a noticeable difference."
        ],
        "imagePath": "assets/beuty.jpg"
      },
      {
        "name": "Classic Leather Belt",
        "price": 29.99,
        "rating": 4.8,
        "stock": 22.0,
        "shortDescription": "Timeless Accessory",
        "description":
            "Complete your look with our Classic Leather Belt. This belt features a versatile design that adds a polished touch to any outfit.",
        "comments": [
          "This leather belt is a staple in my wardrobe. It pairs well with jeans and dress pants.",
          "The quality of the leather and buckle is evident. It's held up beautifully over time.",
          "A must-have accessory for anyone who appreciates classic and functional style."
        ],
        "imagePath": "assets/cloth.jpg"
      },
      {
        "name": "Smart Home Security Camera",
        "price": 129.99,
        "rating": 4.7,
        "stock": 18.0,
        "shortDescription": "Peace of Mind",
        "description":
            "Monitor your home with our Smart Home Security Camera. This camera offers remote access and real-time alerts for added security.",
        "comments": [
          "This security camera has given me peace of mind when I'm away from home.",
          "Setting up and connecting to the camera was straightforward. The app is user-friendly.",
          "The video quality and night vision are impressive. It's a reliable security solution."
        ],
        "imagePath": "assets/electronic.jpg"
      },
      {
        "name": "Luxurious Bathrobe",
        "price": 69.99,
        "rating": 4.9,
        "stock": 20.0,
        "shortDescription": "Spa Comfort",
        "description":
            "Wrap yourself in luxury with our Luxurious Bathrobe. This bathrobe offers plush comfort and a spa-like experience in the comfort of your home.",
        "comments": [
          "I feel like I'm at a spa every time I wear this bathrobe. It's incredibly soft.",
          "The quality and thickness of the fabric make this bathrobe feel truly luxurious.",
          "A treat for yourself or a thoughtful gift for someone special. It's a favorite of mine."
        ],
        "imagePath": "assets/cloth.jpg"
      }
    ];

    for (var item in sampleData) {
      addElectronicItem(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Categories'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addSampleData,
          child: Text('Add Sample Data to Firestore'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: updateitems()));
}
