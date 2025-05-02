import 'package:flutter/material.dart';

final List<Map<String, dynamic>> data = [
  {
    "title": "Annual Leave",
    'icon': Icons.email,
    "start": "2024-12-30 13:47:22",
    'end': "2025-01-30 13:47:22",
    "available": {"label": "Available", "value": 10},
    "used": {
      "label": "Leave Used",
      "value": 5,
    },
  },
  {
    "title": "Sick Leave",
    'icon': Icons.access_time,
    "start": "2024-12-30 13:47:22",
    'end': "2025-01-30 13:47:22",
    "available": {"label": "Available", "value": 14},
    "used": {
      "label": "Leave Used",
      "value": 1,
    },
  },
  {
    "title": "Lakit Leave",
    'icon': Icons.access_time,
    "start": "2024-12-30 13:47:22",
    'end': "2025-01-30 13:47:22",
    "available": {"label": "Available", "value": 7},
    "used": {
      "label": "Leave Used",
      "value": 3,
    },
  },
  {
    "title": "Maternity Leave",
    'icon': Icons.access_time,
    "start": "2024-12-30 13:47:22",
    'end': "2025-01-30 13:47:22",
    "available": {"label": "Available", "value": 150},
    "used": {
      "label": "Leave Used",
      "value": 0,
    },
  },
  {
    "title": "Maternity Leave",
    'icon': Icons.access_time,
    "start": "2024-12-30 13:47:22",
    'end': "2025-01-30 13:47:22",
    "available": {"label": "Available", "value": 150},
    "used": {
      "label": "Leave Used",
      "value": 0,
    },
  }
];

class Logo {
  final String imageUrls;
  final String name;

  Logo({required this.imageUrls, required this.name});
}

List<Logo> logo = [
  Logo(
    imageUrls: 'https://ncc.com.la/assets/naga-market-logo-CPeRkOAy.png',
    name: 'New Concept Consulting (NCC) ',
  ),
  Logo(
    imageUrls: 'https://ncc.com.la/assets/ncc-CpajitjR.png',
    name: 'New Concept Sole (NCS Naga lottery)',
  ),
  Logo(
    imageUrls: 'https://ncc.com.la/assets/ncf-logo-BAWOU7FZ.png',
    name: 'New Concept Microfinance (NCF) ',
  ),
  Logo(
    imageUrls: 'https://ncc.com.la/assets/ncr-logo-DHkbqSod.png',
    name: ' New Concept Real Estate (NCR)',
  ),
];

final attendantListV2 = {
  "data": {
    "total_pages": 1,
    "per_page": 20,
    "current_page": 1,
    "items": [
      {
        "id": 9,
        "user_id": 1,
        "username": "vedjuno",
        "type": "OFFICE",
        "latitude": 17.970259,
        "longitude": 102.623317,
        "title": "",
        "image": "",
        "date": "2025-01-14 15:08:44",
        "title_clock": "Afternoon Check-out",
        "status_late": false,
        "late_minutes": 0,
        "total_hours": "00:00",
        "o_time": 0,
        "status": true,
        "created_at": "2025-01-14 15:08:44",
        "updated_at": "2025-01-14 15:08:44"
      },
      {
        "id": 10,
        "user_id": 1,
        "username": "vedjuno",
        "type": "OFFICE",
        "latitude": 17.970259,
        "longitude": 102.623317,
        "title": "",
        "image": "",
        "date": "2025-01-14 15:08:44",
        "title_clock": "Afternoon Check-out",
        "status_late": false,
        "late_minutes": 0,
        "total_hours": "00:00",
        "o_time": 0,
        "status": true,
        "created_at": "2025-01-14 15:08:44",
        "updated_at": "2025-01-14 15:08:44"
      },
      {
        "id": 11,
        "user_id": 1,
        "username": "vedjuno",
        "type": "OFFICE",
        "latitude": 17.970259,
        "longitude": 102.623317,
        "title": "",
        "image": "",
        "date": "2025-01-14 15:08:44",
        "title_clock": "Afternoon Check-out",
        "status_late": false,
        "late_minutes": 0,
        "total_hours": "00:00",
        "o_time": 0,
        "status": true,
        "created_at": "2025-01-14 15:08:44",
        "updated_at": "2025-01-14 15:08:44"
      },
      {
        "id": 12,
        "user_id": 1,
        "username": "vedjuno",
        "type": "OFFICE",
        "latitude": 17.970259,
        "longitude": 102.623317,
        "title": "",
        "image": "",
        "date": "2025-01-14 15:08:44",
        "title_clock": "Afternoon Check-out",
        "status_late": false,
        "late_minutes": 0,
        "total_hours": "00:00",
        "o_time": 0,
        "status": true,
        "created_at": "2025-01-14 15:08:44",
        "updated_at": "2025-01-14 15:08:44"
      },
    ],
  },
  "status": true
};

final List<Map<String, dynamic>> wardData = [
  {'name': 'Popular vote', 'icons': "assets/logo/vote.png"},
  {'name': 'MVP', 'icons': "assets/logo/mvp.png"},
  {'name': 'performance', 'icons': "assets/logo/per.png"},
  {'name': 'Friendship', 'icons': "assets/logo/frien.png"}
];

final List<Map<String, dynamic>> skillsData = [
  {
    'name': '🧝‍♀️ Dancing',
  },
  {
    'name': '🤾‍♂️ Designing',
  },
  {
    'name': '🤹‍♂️ Religion',
  },
  {
    'name': '🍽️ Cooking',
  },
  {
    'name': ' 🍵 Self-Care',
  },
  {
    'name': '🍔 Food & drink ',
  },
  {
    'name': '🚴‍♂️ Running',
  },
  {
    'name': '🥇 Sport ',
  }
];

final List<Map<String, dynamic>> rankingData = [
  {
    'number': '25',
    'type': 'diamonds',
  },
  {
    'number': '879',
    'type': 'hearts',
  }
];

final mockData = [
  {
    "id": 1,
    "category": "Review",
    "Leave": [
      {
        "id": 1,
        "title": "Annual Leave",
        'icon': 'https://www.svgrepo.com/show/500706/sunny.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "5 Days",
        "statusCheck": "Waiting",
      },
      {
        "id": 2,
        "title": "Lakit Leave",
        'icon': 'https://www.svgrepo.com/show/519762/tinder.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "5 Days",
        "statusCheck": "Approved",
      },
      {
        "id": 3,
        "title": "Sick Leave",
        'icon': 'https://www.svgrepo.com/show/529896/smile-circle.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "5 Days",
        "statusCheck": "Rejected",
      },
      {
        "id": 4,
        "title": "Maternity Leave",
        'icon': 'https://www.svgrepo.com/show/535431/heart-broken.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "5 Days",
        "statusCheck": 'Rejected',
      },
    ]
  },
  {
    "id": 2,
    "category": "Approved",
    "Leave": [
      {
        "id": 2,
        "title": "Lakit Leave",
        'icon': 'https://www.svgrepo.com/show/519762/tinder.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "5 Days",
        "statusCheck": "Approved",
      },
    ]
  },
  {
    "id": 4,
    "category": "Rejected",
    "Leave": [
      {
        "id": 4,
        "title": "Maternity Leave",
        'icon': 'https://www.svgrepo.com/show/535431/heart-broken.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "5 Days",
        "statusCheck": 'Rejected',
      },
    ]
  },
];

final mockDataInformationNew = [
  {
    "id": 1,
    "name": "BOD",
    "users": [
      {
        "name": "Mr. Bouavieng Champaphanh",
        "permission": 'CEO',
        "per": 'CEO',
        "profileImg":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxXnC3fwMwkbIt3ejGRIw3NmbDyUtgS5g2jA&s",
      },
      {
        "number": 35,
        "name": "N.Indavan",
        "permission": 'CBO',
        "per": 'CBO',
        "profileImg":
            "https://huggingface.co/datasets/huggingfacejs/tasks/resolve/main/image-segmentation/image-segmentation-input.jpeg",
      },
      {
        "number": 18,
        "name": "D. Sithixay",
        "permission": 'CTO',
        "per": 'CTO',
        "profileImg": "https://tinypng.com/images/social/website.jpg",
      },
      {
        "number": 38,
        "name": "B. Oudone",
        "permission": 'NCF',
        "per": 'NCf',
        "profileImg":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxXnC3fwMwkbIt3ejGRIw3NmbDyUtgS5g2jA&s",
      },
    ]
  },
  {
    "id": 2,
    "name": "IT",
    "users": [
      {
        "name": "D. Sithixay Duangchack",
        "permission": 'CEO',
        'per': 'CTO',
        "profileImg":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxXnC3fwMwkbIt3ejGRIw3NmbDyUtgS5g2jA&s",
      },
      {
        "name": "Aya Pelson",
        "permission": 'CBO',
        'per': 'Head of It',
        "profileImg":
            "https://huggingface.co/datasets/huggingfacejs/tasks/resolve/main/image-segmentation/image-segmentation-input.jpeg",
      },
      {
        "number": 18,
        "name": "Ninoy",
        "permission": 'CTO',
        'per': 'Vice Head IT',
        "profileImg": "https://tinypng.com/images/social/website.jpg",
      },
      {
        "number": 38,
        "name": "Head Dev",
        "permission": 'NCF',
        'per': 'Head Dev',
        "profileImg":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxXnC3fwMwkbIt3ejGRIw3NmbDyUtgS5g2jA&s",
      },
    ]
  },
  {"id": 3, "name": "Marketing", "users": []},
  {"id": 4, "name": "Sales", "users": []},
];

final mockNotifitions = [
  {
    "id": 1,
    "category": "All",
    "noti": [
      {
        "id": 1,
        "typeLeave": "Sick Leave",
        "date": "22-26 June 2024",
        "user": {
          "name": "Non",
          "profileImg":
              "https://t3.ftcdn.net/jpg/02/35/09/74/360_F_235097419_oW8XQTFySkHTSvGsbRSn61VBRz5mxv1b.jpg",
        },
        "status": true,
        "statusEdit": 'Approved',
      },
      {
        "id": 1,
        "typeLeave": "Lakit Leave",
        "date": "22-26 June 2024",
        "user": {
          "name": "Ved",
          "profileImg":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQphO1iGa3a8wJpd43zAbREvXa8q4DmAIKww&s",
        },
        "status": true,
        "statusEdit": 'Waiting',
      },
      {
        "id": 1,
        "typeLeave": "Maternity Leave",
        "date": "22-26 June 2024",
        "user": {
          "name": "Ved",
          "profileImg":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQphO1iGa3a8wJpd43zAbREvXa8q4DmAIKww&s",
        },
        "status": true,
        "statusEdit": 'Reject',
      },
    ]
  },
  {
    "id": 2,
    "category": "For approval",
    "news": [
      {
        "id": 1,
        "typeLeave": "Sick Leave",
        "date": "22-26 June 2024",
        "user": {
          "name": "Non",
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "status": true,
      },
    ]
  },
  {
    "id": 3,
    "category": "Request",
    "news": [
      {
        "id": 1,
        "typeLeave": "Sick Leave",
        "date": "22-26 June 2024",
        "user": {
          "name": "Non",
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "status": true,
      },
    ]
  },
  {
    "id": 4,
    "category": "Event",
    "news": [
      {
        "id": 1,
        "typeLeave": "Sick Leave",
        "date": "22-26 June 2024",
        "user": {
          "name": "Non",
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "status": true,
      },
    ]
  },
  {
    "id": 5,
    "category": "Meeting",
    "news": [
      {
        "id": 1,
        "typeLeave": "Sick Leave",
        "date": "22-26 June 2024",
        "user": {
          "name": "Non",
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "status": true,
      },
    ]
  },
];

final mockLave = [
  {
    "id": 1,
    "category": "Today (5)",
    "leave": [
      {
        "id": 1,
        "title": "Annual Leave",
        'icon': 'https://www.svgrepo.com/show/500706/sunny.svg',
        'color': '#ffbe0b',
        "date": "17 Dec",
        "status": "Waiting for approval ",
        "user": {
          "dep": 'Marketing',
          "name": 'ved',
          "profileImg":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-C_UAhXq9GfuGO452EEzfbKnh1viQB9EDBQ&s",
        },
        "totalData": "3 Days"
      },
    ]
  },
  {
    "id": 2,
    "category": "This week(10)",
    "leave": [
      {
        "id": 1,
        "title": "Lakit Leave",
        'icon': 'https://www.svgrepo.com/show/529896/smile-circle.svg',
        'color': '#ffbe0b',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "dep": 'IT',
          "name": 'ved',
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "totalData": "5 Days"
      },
    ]
  },
  {
    "id": 3,
    "category": "Next week(2)",
    "leave": [
      {
        "id": 1,
        "title": "Sick Leave",
        'icon': 'https://www.svgrepo.com/show/535431/heart-broken.svg',
        'color': '#2ec4b6',
        "date": "20-26 Sept",
        "status": "Approved at 19 Sept 2024",
        "user": {
          "dep": 'IT',
          "name": 'ved',
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "totalData": "5 Days"
      },
    ]
  },
  {
    "id": 4,
    "category": "Next week(10)",
    "leave": [
      {
        "id": 1,
        "title": "Maternity Leave",
        'icon': 'https://www.svgrepo.com/show/535431/heart-broken.svg',
        'color': '#2ec4b6',
        "date": "20-26 Sept",
        "status": "Approved at 19 Sept 2024",
        "user": {
          "dep": 'IT',
          "name": 'ved',
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "totalData": "5 Days"
      },
    ]
  },
];

final mockDataOT = [
  {
    "id": 1,
    "category": "Review",
    "Leave": [
      {
        "id": 1,
        "title": "OT ມື້ເລກອອກ (ໝອບເໝົາ)",
        'icon': 'https://www.svgrepo.com/show/500706/sunny.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "17:00 - 21:00",
        "statusCheck": "Waiting",
      },
      {
        "id": 2,
        "title": "OT ມື້ປົກກະຕິ",
        'icon': 'https://www.svgrepo.com/show/519762/tinder.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "17:00 - 18:00",
        "statusCheck": "Approved",
      },
      {
        "id": 3,
        "title": "OT ພິເສດ",
        'icon': 'https://www.svgrepo.com/show/529896/smile-circle.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "17:00 - 21:00",
        "statusCheck": "Rejected",
      },
    ]
  },
  {
    "id": 2,
    "category": "Approved",
    "Leave": [
      {
        "id": 2,
        "title": "OT ພິເສດ",
        'icon': 'https://www.svgrepo.com/show/519762/tinder.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "5 Days",
        "statusCheck": "Approved",
      },
    ]
  },
  {
    "id": 4,
    "category": "Rejected",
    "Leave": [
      {
        "id": 4,
        "title": "OT ພິເສດ",
        'icon': 'https://www.svgrepo.com/show/535431/heart-broken.svg',
        'color': '#3a86ff',
        "date": "20-26 Sept",
        "status": "Waiting for approval ",
        "user": {
          "profileImg":
              "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
        },
        "totalData": "5 Days",
        "statusCheck": 'Rejected',
      },
    ]
  },
];

final List dataList = [
  {
    "number": '5',
    "name": 'posts',
  },
  {
    "number": '34',
    "name": 'comments',
  },
  {
    "number": '10',
    "name": 'likes',
  },
];

final mockDataEvent = [
  {
    "id": 1,
    "category": "Sports",
    "event": [
      {
        "id": 1,
        "title": "Luna New year Celebration 2025",
        "description":
            "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...",
        "image":
            "https://snworksceo.imgix.net/dpn-34s/d1c51649-cd92-4a82-859e-dba7687262b2.sized-1000x1000.jpeg?w=1000",
        "user": {
          "name": "King",
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "createAt": "May 30, 2025",
        "time": "Tuesday, 4:00PM - 9:00PM",
        "location": "Vunglao dowkham",
      },
    ]
  },
  {
    "id": 2,
    "category": "Party",
    "event": [
      {
        "id": 1,
        "title": "Luna New year Celebration 2025",
        "description":
            "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...",
        "image":
            "https://www.euroschoolindia.com/wp-content/uploads/2023/06/benefits-of-sports-for-students.jpg",
        "user": {
          "name": "King",
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "createAt": "May 30, 2025",
        "time": "Tuesday, 4:00PM - 9:00PM",
        "location": "Vunglao dowkham",
      },
    ]
  },
  {
    "id": 3,
    "category": "Food",
    "event": [
      {
        "id": 1,
        "title": "Luna New year Celebration 2025",
        "description":
            "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...",
        "image":
            "https://img.freepik.com/free-vector/news-concept-landing-page_52683-11626.jpg?ga=GA1.1.1674328772.1725611728&semt=ais_hybrid",
        "user": {
          "name": "King",
          "profileImg": "http://via.placeholder.com/350x150",
        },
        "createAt": "May 30, 2025",
        "time": "Tuesday, 4:00PM - 9:00PM",
        "location": "Vunglao dowkham",
      },
    ]
  },
];
final event = [
  {
    "id": 1,
    "categoryid": 1,
    "category": "Upcoming",
    "title": "Luna New year Celebration 2025",
    "description":
        "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...",
    "image":
        "https://img.freepik.com/free-vector/news-concept-landing-page_52683-11626.jpg?ga=GA1.1.1674328772.1725611728&semt=ais_hybrid",
    "createAt": "May 30, 2025",
    "time": "Tuesday, 4:00PM - 9:00PM",
    "location": "Vunglao dowkham",
    'date': '12 Fed',
  },
  {
    "id": 2,
    "categoryid": 2,
    "category": "Pastevent",
    "title": "Luna New year Celebration 2025 ",
    "description":
        "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...",
    "image":
        "https://img.freepik.com/free-vector/news-concept-landing-page_52683-11626.jpg?ga=GA1.1.1674328772.1725611728&semt=ais_hybrid",
    "createAt": "May 30, 2025",
    "time": "Tuesday, 4:00PM - 9:00PM",
    "location": "Vunglao dowkham",
    'date': '15 Fed',
  },
];

// final events = [
//   {
//     'date':'2025-05-13 00:00:00',
//     "time": "09:00 AM",
//     "title": "Meeting with Dev team",
//     "duration": "30 minutes",
//     "start": '09 am - 10 am ',
//     "floor": "4 floor",
//     "participants": [
//       "https://i.chzbgr.com/full/9836262400/h06DD08DE",
//       "https://i.chzbgr.com/full/9836262400/h06DD08DE",
//       "https://as1.ftcdn.net/v2/jpg/05/67/05/74/1000_F_567057488_WxhGgAJAWpA8KAzTnYxQZTXS9b9Hr1zm.jpg",
//     ],
//     "color": Colors.blue,
//   },
//   {
//      'date':'2025-05-14 00:00:00',
//     "time": "10:00 AM",
//     "title": "Happy birthday celebration 🎂🎉  ",
//     "duration": "1 hour",
//     "start": '16:30 am - 17:00 am ',
//     "floor": "3 floor",
//     "participants": [
//       "https://imagef2.promeai.pro/process/do/6174ceea7d612c45ebeccc1026e66521.webp?sourceUrl=/g/p/gallery/publish/2023/11/13/0c3b1d24022945619b1fdfae8bfadc4f.png&x-oss-process=image/resize,w_500,h_500/format,webp&sign=baea85498a968ce65aab1c4c3b5c09a4",
//     ],
//     "color": Colors.yellowAccent,
//   },
//   { 
//     'date':'2025-05-15 00:00:00',
//     "time": "11:00 AM",
//     "title": "Meeting with Dev team",
//     "start": '09 am - 10 am ',
//     "duration": "1 hour",
//     "floor": "4 floor",
//     "participants": [
//       "https://as1.ftcdn.net/v2/jpg/05/67/05/74/1000_F_567057488_WxhGgAJAWpA8KAzTnYxQZTXS9b9Hr1zm.jpg",
//     ],
//     "color": Colors.redAccent
//   },
//   {
//     "time": "01:00 PM",
//      'date':'2025-05-20 00:00:00',
//     "title": "Koukham Wedding 👰🏻‍♀️💍🎉  ",
//     "duration": "1 hour",
//     "start": '09 am - 10 am ',
//     "floor": "4 floor",
//     "participants": [
//       "https://ichef.bbci.co.uk/images/ic/480xn/p0jkdrqs.jpg.webp"
//     ],
//     "color": Colors.orangeAccent,
//   },
// ];



final mockReques = [
  {
    "id": 1,
    "category": "Company car",
    "title": "Toyota",
    "time": "8:00 AM - 12:0 0PM",
    "description": "Set up booth in Yhatluang",
    "location": "Parking lot",
    "locationName": "Phonxai temple",
    "status": "Availabe",
    "isstatus": false,
    "statusBooking": true,
  },
  {
    "id": 2,
    "category": "Meeting room",
    "time": "8:00 AM - 12:0 0PM",
    "title": "Toyota",
    "description": "Set up booth in Yhatluang",
    "location": "Parking lot",
    "locationName": "Phonxai temple",
    "status": 'Availabe',
    "isstatus": true,
    "statusBooking": false,
  },
  {
    "id": 3,
    "category": "Equipment request",
    "time": "8:00 AM - 12:0 0PM",
    "title": "Toyota",
    "description": "Set up booth in Yhatluang",
    "location": "Parking lot",
    "locationName": "Phonxai temple",
    "status": 'in Used',
    "isstatus": true,
    "statusBooking": false,
  },
];

final mockOT = [
  {
    "id": 1,
    "keyword": "OT1",
    "title": "OT ມື້ເລກອອກ",
  },
  {
    "id": 2,
    "keyword": "OT2",
    "title": "OT ມື້ປົກກະຕິ",
  },
  {
    "id": 3,
    "keyword": "OT3",
    "title": "OT ມື້ພີເສດ",
  },
];
