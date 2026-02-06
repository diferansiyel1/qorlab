import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// Free Mode page - quick calculator for scratch calculations
/// Results are NOT saved to any experiment
class FreeModePage extends StatefulWidget {
  const FreeModePage({super.key});

  @override
  State<FreeModePage> createState() => _FreeModePageState();
}

class _FreeModePageState extends State<FreeModePage> {
  final _inputController = TextEditingController();
  final List<_CalculationResult> _history = [];
  String _currentResult = '';
  bool _hasError = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Grid pattern background
          CustomPaint(
            painter: _GridPatternPainter(),
            size: Size.infinite,
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(),

                // Warning banner
                _buildWarningBanner(),

                // History / Results
                Expanded(
                  child: _buildHistorySection(),
                ),

                // Input section
                _buildInputSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textMain,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Free Mode',
            style: AppTypography.headlineMedium,
          ),
          const Spacer(),
          if (_history.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _history.clear()),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'CLEAR',
                  style: AppTypography.labelUppercase.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Results are NOT saved to any experiment',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calculate_outlined,
              color: AppColors.textMuted.withValues(alpha: 0.3),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter an expression',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      reverse: true,
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[_history.length - 1 - index];
        return _HistoryCard(
          result: item,
          onCopy: () => _copyToClipboard(item.result),
        );
      },
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Column(
        children: [
          // Result display
          if (_currentResult.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: _hasError
                    ? AppColors.alert.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _currentResult,
                style: AppTypography.dataLarge.copyWith(
                  color: _hasError ? AppColors.alert : AppColors.primary,
                ),
                textAlign: TextAlign.right,
              ),
            ),

          // Input field
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: TextField(
                    controller: _inputController,
                    style: AppTypography.dataMedium,
                    decoration: InputDecoration(
                      hintText: 'e.g., 2.5 * 100 / 1000',
                      hintStyle: AppTypography.labelMedium,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => _evaluate(value),
                    onSubmitted: (value) => _addToHistory(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _addToHistory,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppColors.neonGlow,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.background,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          SafeArea(
            top: false,
            child: const SizedBox(height: 8),
          ),
        ],
      ),
    );
  }

  void _evaluate(String expression) {
    if (expression.isEmpty) {
      setState(() {
        _currentResult = '';
        _hasError = false;
      });
      return;
    }

    try {
      // Simple expression parser - supports basic math
      final result = _parseExpression(expression);
      setState(() {
        _currentResult = '= $result';
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _currentResult = 'Invalid expression';
        _hasError = true;
      });
    }
  }

  double _parseExpression(String expr) {
    // Remove whitespace
    expr = expr.replaceAll(' ', '');

    // Handle parentheses recursively
    while (expr.contains('(')) {
      final start = expr.lastIndexOf('(');
      final end = expr.indexOf(')', start);
      if (end == -1) throw Exception('Unmatched parenthesis');

      final inner = expr.substring(start + 1, end);
      final innerResult = _parseExpression(inner);
      expr = expr.substring(0, start) +
          innerResult.toString() +
          expr.substring(end + 1);
    }

    // Handle addition and subtraction (lowest precedence)
    for (int i = expr.length - 1; i >= 0; i--) {
      if ((expr[i] == '+' || expr[i] == '-') && i > 0) {
        // Make sure it's not a negative sign
        if (i > 0 && !'*/+-(eE'.contains(expr[i - 1])) {
          final left = _parseExpression(expr.substring(0, i));
          final right = _parseExpression(expr.substring(i + 1));
          return expr[i] == '+' ? left + right : left - right;
        }
      }
    }

    // Handle multiplication and division
    for (int i = expr.length - 1; i >= 0; i--) {
      if (expr[i] == '*' || expr[i] == '/') {
        final left = _parseExpression(expr.substring(0, i));
        final right = _parseExpression(expr.substring(i + 1));
        if (expr[i] == '/' && right == 0) throw Exception('Division by zero');
        return expr[i] == '*' ? left * right : left / right;
      }
    }

    // Handle power (^)
    if (expr.contains('^')) {
      final idx = expr.lastIndexOf('^');
      final left = _parseExpression(expr.substring(0, idx));
      final right = _parseExpression(expr.substring(idx + 1));
      return _pow(left, right);
    }

    // Parse number
    return double.parse(expr);
  }

  double _pow(double base, double exp) {
    double result = 1;
    for (int i = 0; i < exp.toInt(); i++) {
      result *= base;
    }
    return result;
  }

  void _addToHistory() {
    if (_inputController.text.isEmpty || _hasError) return;

    setState(() {
      _history.add(_CalculationResult(
        expression: _inputController.text,
        result: _currentResult.replaceFirst('= ', ''),
        timestamp: DateTime.now(),
      ));
      _inputController.clear();
      _currentResult = '';
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _CalculationResult {
  final String expression;
  final String result;
  final DateTime timestamp;

  _CalculationResult({
    required this.expression,
    required this.result,
    required this.timestamp,
  });
}

class _HistoryCard extends StatelessWidget {
  final _CalculationResult result;
  final VoidCallback onCopy;

  const _HistoryCard({
    required this.result,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.expression,
                    style: AppTypography.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '= ${result.result}',
                    style: AppTypography.dataMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onCopy,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.copy_rounded,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.glassBorder.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    const gridSize = 24.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
