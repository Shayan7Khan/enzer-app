class UserProfile {
  String? id;
  String? fullName;
  String? phone;
  String? cnic;
  String? signupReferralCode;
  String? signupReferralId;
  String? avatarUrl;
  bool isDeleted;
  DateTime? createdAt;
  String? statusId;
  String? statusName; // joined from member_statuses

  UserProfile({
    this.id,
    this.fullName,
    this.phone,
    this.cnic,
    this.signupReferralCode,
    this.signupReferralId,
    this.avatarUrl,
    this.isDeleted = false,
    this.createdAt,
    this.statusId,
    this.statusName,
  });

  UserProfile.fromJson(Map<String, dynamic> json)
    : isDeleted = json['is_deleted'] ?? false {
    id = json['id'];
    fullName = json['full_name'];
    phone = json['phone'];
    cnic = json['cnic'];
    signupReferralCode = json['signup_referral_code'];
    signupReferralId = json['signup_referral_id'];
    avatarUrl = json['avatar_url'];
    createdAt = json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null;
    statusId = json['status_id'];
    // joined from member_statuses table
    final statusData = json['member_statuses'];
    statusName = statusData is Map ? statusData['name'] : null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'phone': phone,
    'cnic': cnic,
    'signup_referral_code': signupReferralCode,
    'signup_referral_id': signupReferralId,
    'avatar_url': avatarUrl,
    'is_deleted': isDeleted,
    'status_id': statusId,
    'created_at': createdAt?.toIso8601String(),
  };

  UserProfile deepCopy() {
    return UserProfile(
      id: id,
      fullName: fullName,
      phone: phone,
      cnic: cnic,
      signupReferralCode: signupReferralCode,
      signupReferralId: signupReferralId,
      avatarUrl: avatarUrl,
      isDeleted: isDeleted,
      statusId: statusId,
      statusName: statusName,
      createdAt: createdAt,
    );
  }
}
