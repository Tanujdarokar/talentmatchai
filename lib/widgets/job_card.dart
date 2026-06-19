import 'package:flutter/material.dart';
import '../models/mock_models.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;

  const JobCard({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.05)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.business_center_rounded, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${job.department} • ${job.type}',
                          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(job.status),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildInfoChip(context, Icons.people_outline_rounded, '${job.applicantsCount} Applicants'),
                  const SizedBox(width: 12),
                  _buildInfoChip(context, Icons.timer_outlined, job.experience),
                ],
              ),
              const SizedBox(height: 20),
              Divider(height: 1, color: Theme.of(context).dividerColor.withOpacity(0.1)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('AI Ranking Completed', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: [
                        Text('View Details', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                        Icon(Icons.chevron_right_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive = status == 'Active';
    Color color = isActive ? Colors.green : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}
