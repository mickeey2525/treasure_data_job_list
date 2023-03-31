class Job {
  final String jobId;
  final String createdAt;
  final String type;
  final String status;

  Job({required this.jobId, required this.createdAt,required this.type, required this.status});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobId: json['job_id'],
      createdAt: json['created_at'],
      type: json['type'],
      status: json['status'],
    );
  }
}
