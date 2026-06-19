class Job {
  final String id;
  final String title;
  final String department;
  final String type;
  final String experience;
  final int expRequiredMin;
  final String status;
  final int applicantsCount;
  final List<String> requiredSkills;

  Job({
    required this.id,
    required this.title,
    required this.department,
    required this.type,
    required this.experience,
    required this.expRequiredMin,
    required this.status,
    required this.applicantsCount,
    required this.requiredSkills,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      type: json['employmentType']?.toString() ?? '',
      expRequiredMin: int.tryParse(json['experience_required_min']?.toString() ?? '0') ?? 0,
      experience: "${json['experience_required_min'] ?? 0}+ years",
      status: json['status']?.toString() ?? 'Open',
      applicantsCount: 0,
      requiredSkills: List<String>.from(json['required_skills'] ?? []),
    );
  }
}

class Candidate {
  final String id;
  final String name;
  final String role;
  final String experience;
  final double matchScore;
  final List<String> skills;
  final String photoUrl;
  final bool isBookmarked;

  Candidate({
    required this.id,
    required this.name,
    required this.role,
    required this.experience,
    required this.matchScore,
    required this.skills,
    this.photoUrl = 'https://i.pravatar.cc/150',
    this.isBookmarked = false,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    String rawScore = (json['final_score'] ?? json['matchScore'] ?? '0').toString();
    return Candidate(
      id: json['_id']?.toString() ?? '',
      name: json['fullName']?.toString() ?? '',
      role: json['currentRole']?.toString() ?? '',
      experience: "${json['experience_years'] ?? 0} yrs",
      matchScore: double.tryParse(rawScore) ?? 0.0,
      skills: List<String>.from(json['skills'] ?? []),
      photoUrl: 'https://i.pravatar.cc/150?u=${json['_id']}',
    );
  }
}

class RankingResult {
  final int rank;
  final Candidate candidate;
  final String recommendation;
  final Map<String, dynamic> breakdown;

  RankingResult({
    required this.rank,
    required this.candidate,
    required this.recommendation,
    required this.breakdown,
  });

  factory RankingResult.fromJson(Map<String, dynamic> json) {
    double semantic = double.tryParse((json['semanticScore'] ?? '0').toString()) ?? 0.0;
    double skill = double.tryParse((json['skillScore'] ?? '0').toString()) ?? 0.0;
    double experience = double.tryParse((json['experienceScore'] ?? '0').toString()) ?? 0.0;

    return RankingResult(
      rank: 0, // Assigned by list order
      candidate: Candidate.fromJson(json['candidateId'] ?? {}),
      recommendation: json['recommendation']?.toString() ?? '',
      breakdown: {
        'Semantic': semantic / 40,
        'Skill': skill / 15,
        'Experience': experience / 25,
      },
    );
  }
}
