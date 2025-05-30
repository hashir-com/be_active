import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.favorite_rounded,
                color: Theme.of(context).primaryColor,
                size: 80,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Thryv – Healthy Habit Tracker',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Thrive to Achieve',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const Divider(height: 32, thickness: 1.5),
            const Text(
              '🌱 Our Mission',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'At Thryv, we believe that progress starts with small steps. Our mission is to help you thrive—not just survive—by guiding you to set meaningful goals, track your progress, and stay motivated every day.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              '💡 What Makes Thryv Different?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            bulletPoint(
              '🔄 Habit Loop Focused: Based on proven behavioral psychology.',
            ),
            bulletPoint(
              '📊 Personalized Tracking: Meals, workouts, sleep, hydration.',
            ),
            bulletPoint(
              '🧘 Holistic Wellness: Journaling, mood tracking, self-care.',
            ),
            bulletPoint(
              '🎯 Goal-Oriented Design: Progress charts and milestone tracking.',
            ),
            bulletPoint('🤝 Built for Everyone: For beginners and pros alike.'),
            const SizedBox(height: 24),
            const Text(
              '🚀 Why the Name "Thryv"?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We chose the name "Thryv" as a symbol of energy, purpose, and growth. The \'y\' in Thryv represents your journey—unique, powerful, and worth celebrating.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              '🧭 Our Vision',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'To be more than a tracker—a true wellness partner that motivates, educates, and inspires users to take small consistent actions for lifelong transformation.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              '🙌 Join Our Community',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thryv is more than an app—it’s a movement. Whether you’re trying to start a morning routine, eat better, or move more, we’re here to support your journey.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              '📬 We’re Listening',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your feedback helps us grow. Reach out via the app or email us at support@thryvhealth.app.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Thank you for choosing Thryv 💚',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Bullet point helper widget
  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

class Appversion extends StatelessWidget {
  const Appversion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text("         thryv \nVersion : v1.0.0.0"),
        ),
      ),
    );
  }
}

class Liscence extends StatelessWidget {
  const Liscence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📜 Terms & Conditions'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.shield_outlined,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Thryv – Healthy Habit Tracker 💪',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Thrive to Achieve 🌱',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
            const Divider(height: 32, thickness: 1.5),
            buildSection(
              title: '1️⃣ Acceptance of Terms',
              content:
                  'By using Thryv, you agree to these Terms & our Privacy Policy. If you disagree, please don’t use the app 🚫.',
              context: context,
            ),
            buildSection(
              title: '2️⃣ Use of Thryv',
              content:
                  'This app is for your personal wellness journey 🧘‍♂️. Use it respectfully, ethically, and legally ✅.',
              context: context,
            ),
            buildSection(
              title: '3️⃣ Your Data',
              content:
                  'Your data is saved only on your device using secure local storage 🔐 (Hive). We do not share or sell any data 💯 private!',
              context: context,
            ),
            buildSection(
              title: '4️⃣ Intellectual Property',
              content:
                  'All content in Thryv (💚 design, logo, features) belongs to us. Please don’t copy, modify, or distribute without permission.',
              context: context,
            ),
            buildSection(
              title: '5️⃣ Updates & Changes',
              content:
                  'We may update these terms or features from time to time 🔄. By continuing to use the app, you accept the changes.',
              context: context,
            ),
            buildSection(
              title: '6️⃣ Warranty Disclaimer',
              content:
                  'Thryv is provided “as is” 🛠️. While we strive for excellence, we’re not liable for any data loss, bugs, or issues encountered 🐞.',
              context: context,
            ),
            buildSection(
              title: '7️⃣ Termination of Use',
              content:
                  'We reserve the right to suspend or terminate your access if the app is misused 🚫.',
              context: context,
            ),
            buildSection(
              title: '8️⃣ Contact Us',
              content:
                  'Have questions or suggestions? 💌 Reach out to us at:\n📧 support@thryvhealth.app',
              context: context,
            ),
            const SizedBox(height: 28),
            Center(
              child: Text(
                'Thanks for using Thryv 🌟\nLet’s thrive together! 🚀',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Reusable section builder with emoji styling
Widget buildSection({
  required BuildContext context,
  required String title,
  required String content,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    ),
  );
}
