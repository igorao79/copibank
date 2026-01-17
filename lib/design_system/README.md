# Banking Design System

A comprehensive design system for modern banking applications built with Flutter. This system provides a complete set of reusable components, design tokens, and patterns optimized for financial services.

## 🎨 Foundation

### Color System
- **Primary Colors**: Blue banking palette (50-900 shades)
- **Secondary Colors**: Teal accent colors (50-900 shades)
- **Neutral Colors**: 12-step grayscale for backgrounds and text
- **Semantic Colors**: Success, Warning, Error, Info (5 shades each)
- **Special Banking Colors**: Money amounts, gradients, status indicators

### Typography
- **Modular Scale**: 7 font sizes (12px to 72px)
- **Font Weights**: Light (300) to Extra Bold (800)
- **Line Heights**: Tight (1.25), Normal (1.5), Relaxed (1.625)
- **Letter Spacing**: Tight (-0.025) to Wide (0.05)
- **Text Styles**: Display, Heading (1-4), Body (Large/Regular/Small), Caption, Overline
- **Custom Fonts**: Iciel (headings), Berlin (body text) - TTF format

### Design Tokens
- **Spacing**: 4px base unit (4, 8, 12, 16, 24, 32, 48, 64, 80, 96)
- **Border Radius**: Small (4px), Medium (8px), Large (12px), Full (9999px)
- **Shadows**: 4 elevation levels with appropriate blur and offset
- **Component Sizes**: Button heights, input heights, icon sizes, avatar sizes

## 🧩 Components

### Buttons
```dart
// Primary action button
BankingButtons.primary(
  text: 'Continue',
  onPressed: () => print('Pressed'),
);

// Secondary button
BankingButtons.secondary(
  text: 'Cancel',
  onPressed: () => print('Cancelled'),
);

// Tertiary (outline) button
BankingButtons.tertiary(
  text: 'Learn More',
  onPressed: () => print('Learn more'),
);

// Destructive action
BankingButtons.destructive(
  text: 'Delete',
  onPressed: () => print('Deleted'),
);

// Icon-only button
BankingButtons.icon(
  icon: Icons.add,
  onPressed: () => print('Add'),
);
```

### Inputs
```dart
// Text input
BankingInputs.text(
  label: 'Full Name',
  hint: 'Enter your full name',
  onChanged: (value) => print(value),
);

// Password input
BankingInputs.password(
  label: 'Password',
  hint: 'Enter your password',
  onChanged: (value) => print(value),
);

// Amount input
BankingInputs.amount(
  label: 'Transfer Amount',
  currency: '\$',
  onChanged: (value) => print(value),
);

// Search input
BankingInputs.search(
  hint: 'Search transactions...',
  onChanged: (value) => print(value),
);
```

### Cards
```dart
// Account card
BankingCards.account(
  title: 'Main Account',
  amount: '\$15,420.75',
  subtitle: 'Checking',
  onTap: () => print('Account tapped'),
);

// Transaction card
BankingCards.transaction(
  title: 'Amazon Purchase',
  amount: '-\$89.99',
  subtitle: 'Today',
  icon: Icons.shopping_cart,
);

// Quick action card
BankingCards.quickAction(
  title: 'Transfer',
  icon: Icons.send,
  onTap: () => print('Transfer tapped'),
);
```

### Fintech Components
```dart
// Line chart
BankingLineChart(
  data: chartData,
  title: 'Balance Trend',
);

// Donut chart
BankingDonutChart(
  data: portfolioData,
  centerText: 'Total',
  centerSubtitle: '\$25,000',
);

// Amount input
BankingAmountInput(
  label: 'Transfer Amount',
  currency: '\$',
  onChanged: (value) => print(value),
);

// Numpad
BankingNumpad(
  onKeyPressed: (key) => print('Key: $key'),
  onDelete: () => print('Delete'),
);
```

## 🎭 Themes

The design system supports both light and dark themes with automatic adaptation:

```dart
MaterialApp(
  theme: BankingTheme.light,
  darkTheme: BankingTheme.dark,
  themeMode: ThemeMode.system,
  // ...
);
```

## 📱 Screens

## 📱 Screens

### Dashboard (Мой банк)
- Balance display with animated updates
- Account cards carousel
- Quick actions grid
- Interactive charts
- Recent transactions list
- Staggered animations
- **Theme toggle button** in app bar (cycles: System → Light → Dark → System)

### Transactions (История)
- **Real-time search functionality** with instant filtering
- **Date range picker** for custom period selection
- **Comprehensive expense analytics** with income/expense breakdown
- **Top spending categories** with percentages
- **Transaction count and average amount** statistics
- **Smart filtering** by search query and date range
- Clear filters button when active

### Chats (Чаты)
- Lottie animation (mail.json) at the top
- Two main chats: Уведомления (Notifications) and Тех поддержка (Tech Support)
- Support chat system with unread message indicators
- Clean centered layout with proper spacing
- No quick actions (removed for cleaner design)

### Support Chat (Тех поддержка)
- AI-powered robot assistant with compact oval question buttons in grid layout
- Popular questions: payments, card blocking, PIN change, notifications, security
- Real-time chat interface with message bubbles and timestamps
- Support specialist escalation for complex issues
- Quick actions menu for chat management

### Notifications Chat (Уведомления)
- Interactive notification center with detailed views
- Mark as read/unread functionality
- Swipe-to-delete notifications
- Categorized notifications: success, warning, info, promotions
- Notification history and management

### Cards (Оформить)
- Card management interface
- Card action buttons (block, PIN change, NFC)
- Card information display
- Add new card functionality

## 🎨 **Color Scheme**
- **Light Theme**: White background with light blue accents + SVG gradient background
- **Dark Theme**: Dark blue background with darker blue accents + SVG gradient background
- **Primary Colors**: Blue spectrum (50-900 shades)
- **Semantic Colors**: Success, Warning, Error states

## 🎭 **Visual Design**
- **SVG Backgrounds**: Adaptive gradient wave backgrounds that change with theme (light blue waves / dark blue waves)
- **Material Design 3**: Modern UI components with proper theming
- **Responsive Layout**: Optimized for different screen sizes
- **Smooth Animations**: Staggered animations and micro-interactions

## 🧭 **Navigation**
Bottom navigation bar with 4 tabs:
1. **Мой банк** - Dashboard and main banking functions
2. **История** - Transaction history and payments
3. **Чаты** - Customer support and communication
4. **Оформить** - Card management and new applications

## 🔄 Animations & Interactions

### Micro-interactions
1. **Card Hover/Tap**: Scale animation on quick action cards
2. **Balance Updates**: Pulse animation when balance changes
3. **Button States**: Smooth color and elevation transitions
4. **Screen Transitions**: Fade and slide animations
5. **Loading States**: Smooth progress indicators

### Staggered Animations
- Sequential reveal of dashboard sections
- Smooth transitions between states
- Performance-optimized animations

## 📋 Do's and Don'ts

### Buttons
✅ **Do**:
- Use primary buttons for main actions
- Keep button text concise and action-oriented
- Use appropriate button variants for different contexts
- Ensure sufficient touch targets (44px minimum)

❌ **Don't**:
- Use multiple primary buttons in the same view
- Make buttons too small on mobile devices
- Use generic text like "Click Here" or "Submit"

### Cards
✅ **Do**:
- Use cards to group related information
- Include clear visual hierarchy
- Make cards tappable when they contain actions
- Use appropriate shadows for elevation

❌ **Don't**:
- Overload cards with too much information
- Use cards for navigation when buttons are more appropriate
- Remove shadows completely (breaks visual hierarchy)

### Colors
✅ **Do**:
- Use semantic colors for status indicators
- Maintain sufficient contrast ratios (4.5:1 minimum)
- Use color to reinforce information hierarchy
- Test color combinations in both themes

❌ **Don't**:
- Use color as the only way to convey information
- Create custom colors outside the design system
- Use low-contrast color combinations

### Typography
✅ **Do**:
- Use the modular scale for consistent sizing
- Maintain proper text hierarchy
- Ensure readable line lengths (45-75 characters)
- Use appropriate font weights for emphasis

❌ **Don't**:
- Use font sizes outside the modular scale
- Create custom text styles
- Use all caps for body text
- Ignore accessibility font size requirements

### Spacing
✅ **Do**:
- Use the spacing scale for consistent layouts
- Maintain proper visual rhythm
- Group related elements with consistent spacing
- Consider touch targets and accessibility

❌ **Don't**:
- Use arbitrary spacing values
- Create cramped or overcrowded layouts
- Ignore platform-specific spacing guidelines

## 🚀 Getting Started

1. **Install Dependencies**:
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  fl_chart: ^0.66.1
  flutter_form_builder: ^9.2.1
  intl: ^0.19.0
  font_awesome_flutter: ^10.7.0
  flutter_staggered_animations: ^1.1.1
  flutter_svg: ^2.0.9
  lottie: ^3.1.2
```

2. **Add Custom Fonts** (Optional):
Replace placeholder files with actual TTF fonts:
```
assets/fonts/iciel-regular.ttf (replace with real Iciel font)
assets/fonts/berlin-regular.ttf (replace with real Berlin font)
```

The fonts are already configured in `pubspec.yaml`:
```yaml
fonts:
  - family: Iciel
    fonts:
      - asset: assets/fonts/iciel-regular.ttf
        weight: 400
  - family: Berlin
    fonts:
      - asset: assets/fonts/berlin-regular.ttf
        weight: 400
```

Font families are already set in `lib/design_system/themes/banking_theme.dart`.

2. **Import the Design System**:
```dart
import 'design_system/design_system.dart';
```

3. **Use Components**:
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Banking App', style: BankingTypography.heading3),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => appState.toggleTheme(),
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(BankingTokens.screenHorizontalPadding),
        child: Column(
          children: [
            BankingCards.account(
              title: 'Main Account',
              amount: '\$15,420.75',
              onTap: () => print('Account tapped'),
            ),
            const SizedBox(height: BankingTokens.space16),
            BankingButtons.primary(
              text: 'Transfer Money',
              onPressed: () => print('Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
```

4. **Theme Management**:
```dart
// Toggle theme in any widget
context.read<AppState>().toggleTheme();

// Listen to theme changes
final appState = context.watch<AppState>();
final currentTheme = appState.themeMode; // ThemeMode.system, .light, or .dark
```

## 🎯 Best Practices

1. **Consistency**: Always use design system components instead of custom implementations
2. **Accessibility**: Ensure proper contrast ratios and touch target sizes
3. **Performance**: Use animations judiciously and profile for smooth performance
4. **Testing**: Test all components in both light and dark themes
5. **Documentation**: Keep component usage documentation up to date

## 🔧 Customization

The design system is built to be flexible while maintaining consistency:

- **Colors**: Extend the color palette for brand-specific needs
- **Components**: Create composite components using base components
- **Themes**: Customize themes while maintaining the core color relationships
- **Typography**: Add brand fonts while following the scale and hierarchy

## 📊 Performance Considerations

- Components are optimized for rebuild performance
- Animations use hardware acceleration where possible
- Large lists use efficient scrolling techniques
- Theme changes are optimized to minimize rebuilds

## 📝 **Recent Updates**
- ✅ Fixed black text issue in dark theme - proper color inheritance
- ✅ Added custom font support (Iciel for headings, Berlin for body text)
- ✅ Implemented adaptive SVG backgrounds for all screens
- ✅ Enhanced transaction analytics with comprehensive expense breakdown
- ✅ Added real-time search functionality with instant filtering
- ✅ Fixed layout overflow issues with proper SafeArea usage
- ✅ Improved color scheme with blue gradients and proper contrast

---

Built with ❤️ for modern banking applications
