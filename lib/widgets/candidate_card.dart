import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/mock_models.dart';

class CandidateCard extends StatelessWidget {
  final Candidate candidate;
  final VoidCallback? onTap;

  const CandidateCard({super.key, required this.candidate, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: candidate.photoUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: Colors.grey.shade200),
                            errorWidget: (context, url, error) => Icon(Icons.person, color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.cardColor, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          candidate.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: -0.5),
                        ),
                        Text(
                          candidate.role,
                          style: TextStyle(color: theme.textTheme.bodySmall?.color?.withOpacity(0.6), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  _buildMatchScoreBadge(candidate.matchScore),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: candidate.skills.take(4).where((s) => s.isNotEmpty).map((skill) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.1)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history_rounded, size: 16, color: theme.textTheme.bodySmall?.color?.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text('${candidate.experience} experience', style: TextStyle(color: theme.textTheme.bodySmall?.color?.withOpacity(0.6), fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_border_rounded, size: 20),
                        visualDensity: VisualDensity.compact,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(0, 0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('View Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchScoreBadge(double score) {
    Color color = score >= 90 ? Colors.green : (score >= 70 ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${score.toInt()}%',
            style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: -0.5),
          ),
          Text(
            'MATCH',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 8),
          ),
        ],
      ),
    );
  }
}
