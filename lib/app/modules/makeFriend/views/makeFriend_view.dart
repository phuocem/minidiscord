import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/makeFriend_controller.dart';
import '../../../data/models/ProfileModel.dart';

class MakeFriendView extends StatelessWidget {
  final MakeFriendController controller = Get.put(MakeFriendController());

  MakeFriendView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildSearchTab(),
                    _buildFriendRequestsTab(),
                    _buildSentRequestsTab(),
                    _buildFriendsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            "Kết Bạn",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 5, color: Colors.black45)],
            ),
          ),
          TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Tìm kiếm"),
              Tab(text: "Lời mời"),
              Tab(text: "Đã gửi"),
              Tab(text: "Bạn bè"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.searchResults.isEmpty) {
              return const Text(
                "Không có kết quả tìm kiếm",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              );
            }
            return Column(
              children: controller.searchResults
                  .map((ProfileModel user) => _buildUserCard(
                user,
                ElevatedButton(
                  onPressed: () =>
                      controller.sendFriendRequest(user.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                  ),
                  child: const Text("Kết bạn"),
                ),
              ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFriendRequestsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadFriendRequests();
      },
      child: Obx(() {
        if (controller.friendRequests.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 200),
              Center(
                child: Text(
                  "Không có lời mời kết bạn",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          );
        }
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: controller.friendRequests
              .map((fr) => _buildUserCard(
            fr.senderProfile,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => controller.acceptFriendRequest(
                      fr.request.id, fr.senderProfile.id),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () =>
                      controller.rejectFriendRequest(fr.request.id),
                ),
              ],
            ),
          ))
              .toList(),
        );
      }),
    );
  }


  Widget _buildSentRequestsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (controller.sentRequests.isEmpty) {
          return const Text(
            "Không có lời mời đã gửi",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          );
        }
        return Column(
          children: controller.sentRequests
              .map((sr) => _buildUserCard(
            sr.receiverProfile,
            ElevatedButton(
              onPressed: () =>
                  controller.cancelFriendRequest(sr.request.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
              ),
              child: const Text("Hủy"),
            ),
          ))
              .toList(),
        );
      }),
    );
  }

  Widget _buildFriendsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadFriends(); // gọi lại API
      },
      child: Obx(() {
        if (controller.friends.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 200),
              Center(
                child: Text(
                  "Bạn chưa có bạn bè nào",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          );
        }
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: controller.friends
              .map((f) => _buildUserCard(
            f,
            IconButton(
              icon: const Icon(Icons.message_outlined, color: Colors.blue),
              onPressed: () {
                // Navigate to chat detail, pass friend id
                Get.toNamed('/detail-chat', arguments: {'friendId': f.id});
              },
            ),
          ))
              .toList(),
        );
      }),
    );
  }
  Widget _buildUserCard(ProfileModel user, Widget action) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage:
          user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
          child: user.avatarUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text(user.username ?? ''),
        subtitle: Text(user.email ?? ''),
        trailing: action,
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Tìm kiếm bạn bè...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) => controller.searchUsers(value),
    );
  }

  void _showQuickActions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Tùy chọn nhanh"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Tìm kiếm bạn bè"),
              onTap: () {
                Navigator.pop(context);
                DefaultTabController.of(context).animateTo(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Xem lời mời"),
              onTap: () {
                Navigator.pop(context);
                DefaultTabController.of(context).animateTo(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text("Lời mời đã gửi"),
              onTap: () {
                Navigator.pop(context);
                DefaultTabController.of(context).animateTo(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Danh sách bạn bè"),
              onTap: () {
                Navigator.pop(context);
                DefaultTabController.of(context).animateTo(3);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }
}
