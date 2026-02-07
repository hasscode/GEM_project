class DashboardState {
  final int total;
  final int verified;
  final int remaining;

  const DashboardState({
    this.total = 0,
    this.verified = 0,
    this.remaining = 0,
  });

  DashboardState copyWith({
    int? total,
    int? verified,
    int? remaining,
  }) {
    return DashboardState(
      total: total ?? this.total,
      verified: verified ?? this.verified,
      remaining: remaining ?? this.remaining,
    );
  }
}
