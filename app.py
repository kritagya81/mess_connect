from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import pymysql
from datetime import datetime

app = Flask(__name__)
CORS(app)

# MySQL Configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'kritagya1688',  # CHANGE THIS TO YOUR MYSQL PASSWORD
    'database': 'hostel_mess_db',
    'cursorclass': pymysql.cursors.DictCursor
}

def get_db():
    """Get database connection"""
    return pymysql.connect(**DB_CONFIG)

# ==================== MENU ROUTES ====================

@app.route('/api/menu/<day>', methods=['GET'])
def get_menu(day):
    """Get menu for a specific day"""
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("""
            SELECT m.id, m.meal_type, m.time_slot, 
                   GROUP_CONCAT(mi.item_name SEPARATOR '||') as items
            FROM meals m
            LEFT JOIN menu_items mi ON m.id = mi.meal_id
            WHERE m.day_of_week = %s
            GROUP BY m.id, m.meal_type, m.time_slot
            ORDER BY FIELD(m.meal_type, 'Breakfast', 'Lunch', 'Snacks', 'Dinner')
        """, (day,))
        meals = cur.fetchall()
        cur.close()
        db.close()
        
        # Format the response
        formatted_meals = {}
        for meal in meals:
            formatted_meals[meal['meal_type']] = {
                'id': meal['id'],
                'items': meal['items'].split('||') if meal['items'] else [],
                'time': meal['time_slot']
            }
        
        return jsonify({'success': True, 'data': formatted_meals})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/menu/week', methods=['GET'])
def get_weekly_menu():
    """Get complete weekly menu"""
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("""
            SELECT m.day_of_week, m.meal_type, m.time_slot,
                   GROUP_CONCAT(mi.item_name SEPARATOR '||') as items
            FROM meals m
            LEFT JOIN menu_items mi ON m.id = mi.meal_id
            GROUP BY m.id, m.day_of_week, m.meal_type, m.time_slot
            ORDER BY FIELD(m.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 
                          'Thursday', 'Friday', 'Saturday', 'Sunday'),
                     FIELD(m.meal_type, 'Breakfast', 'Lunch', 'Snacks', 'Dinner')
        """)
        meals = cur.fetchall()
        cur.close()
        db.close()
        
        # Format the response
        weekly_menu = {}
        for meal in meals:
            day = meal['day_of_week']
            if day not in weekly_menu:
                weekly_menu[day] = {}
            
            weekly_menu[day][meal['meal_type']] = {
                'items': meal['items'].split('||') if meal['items'] else [],
                'time': meal['time_slot']
            }
        
        return jsonify({'success': True, 'data': weekly_menu})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/menu/update', methods=['PUT'])
def update_menu():
    """Update menu items for a meal"""
    try:
        data = request.json
        meal_id = data.get('meal_id')
        items = data.get('items', [])
        
        db = get_db()
        cur = db.cursor()
        
        # Delete existing items
        cur.execute("DELETE FROM menu_items WHERE meal_id = %s", (meal_id,))
        
        # Insert new items
        for item in items:
            cur.execute("""
                INSERT INTO menu_items (meal_id, item_name) 
                VALUES (%s, %s)
            """, (meal_id, item))
        
        db.commit()
        cur.close()
        db.close()
        
        return jsonify({'success': True, 'message': 'Menu updated successfully'})
    except Exception as e:
        db.rollback()
        db.close()
        return jsonify({'success': False, 'error': str(e)}), 500


# ==================== NOTICES ROUTES ====================

@app.route('/api/notices', methods=['GET'])
def get_notices():
    """Get all notices"""
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("""
            SELECT id, title, message, date_posted 
            FROM notices 
            ORDER BY date_posted DESC
        """)
        notices = cur.fetchall()
        cur.close()
        db.close()
        
        return jsonify({'success': True, 'data': notices})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/notices', methods=['POST'])
def add_notice():
    """Add a new notice"""
    try:
        data = request.json
        title = data.get('title')
        message = data.get('message')
        
        db = get_db()
        cur = db.cursor()
        cur.execute("""
            INSERT INTO notices (title, message, date_posted) 
            VALUES (%s, %s, %s)
        """, (title, message, datetime.now().date()))
        db.commit()
        
        notice_id = cur.lastrowid
        cur.close()
        db.close()
        
        return jsonify({
            'success': True, 
            'message': 'Notice added successfully',
            'id': notice_id
        })
    except Exception as e:
        db.rollback()
        db.close()
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/notices/<int:notice_id>', methods=['DELETE'])
def delete_notice(notice_id):
    """Delete a notice"""
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("DELETE FROM notices WHERE id = %s", (notice_id,))
        db.commit()
        cur.close()
        db.close()
        
        return jsonify({'success': True, 'message': 'Notice deleted successfully'})
    except Exception as e:
        db.rollback()
        db.close()
        return jsonify({'success': False, 'error': str(e)}), 500


# ==================== FEEDBACK ROUTES ====================

@app.route('/api/feedback', methods=['GET'])
def get_feedback():
    """Get all feedback"""
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("""
            SELECT id, student_name, meal, rating, comment, 
                   date_posted, verified 
            FROM feedback 
            ORDER BY date_posted DESC
        """)
        feedbacks = cur.fetchall()
        cur.close()
        db.close()
        
        return jsonify({'success': True, 'data': feedbacks})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/feedback', methods=['POST'])
def submit_feedback():
    """Submit new feedback"""
    try:
        data = request.json
        student_name = data.get('name')
        meal = data.get('meal')
        rating = data.get('rating')
        comment = data.get('comment')
        
        db = get_db()
        cur = db.cursor()
        cur.execute("""
            INSERT INTO feedback (student_name, meal, rating, comment, date_posted, verified) 
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (student_name, meal, rating, comment, datetime.now().date(), False))
        db.commit()
        
        feedback_id = cur.lastrowid
        cur.close()
        db.close()
        
        return jsonify({
            'success': True, 
            'message': 'Feedback submitted successfully',
            'id': feedback_id
        })
    except Exception as e:
        db.rollback()
        db.close()
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/feedback/<int:feedback_id>', methods=['DELETE'])
def delete_feedback(feedback_id):
    """Delete feedback"""
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("DELETE FROM feedback WHERE id = %s", (feedback_id,))
        db.commit()
        cur.close()
        db.close()
        
        return jsonify({'success': True, 'message': 'Feedback deleted successfully'})
    except Exception as e:
        db.rollback()
        db.close()
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/feedback/<int:feedback_id>/verify', methods=['PUT'])
def verify_feedback(feedback_id):
    """Verify feedback"""
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("UPDATE feedback SET verified = TRUE WHERE id = %s", (feedback_id,))
        db.commit()
        cur.close()
        db.close()
        
        return jsonify({'success': True, 'message': 'Feedback verified successfully'})
    except Exception as e:
        db.rollback()
        db.close()
        return jsonify({'success': False, 'error': str(e)}), 500


# ==================== STATISTICS ROUTES ====================

@app.route('/api/stats', methods=['GET'])
def get_statistics():
    """Get mess statistics"""
    try:
        db = get_db()
        cur = db.cursor()
        
        # Average rating
        cur.execute("SELECT AVG(rating) as avg_rating FROM feedback")
        avg_rating = cur.fetchone()['avg_rating'] or 0
        
        # Total feedback count
        cur.execute("SELECT COUNT(*) as total_feedback FROM feedback")
        total_feedback = cur.fetchone()['total_feedback']
        
        # Rating distribution
        cur.execute("""
            SELECT rating, COUNT(*) as count 
            FROM feedback 
            GROUP BY rating 
            ORDER BY rating DESC
        """)
        rating_dist = cur.fetchall()
        
        # Most popular items (from feedback)
        cur.execute("""
            SELECT meal, COUNT(*) as feedback_count 
            FROM feedback 
            GROUP BY meal 
            ORDER BY feedback_count DESC 
            LIMIT 5
        """)
        popular_meals = cur.fetchall()
        
        cur.close()
        db.close()
        
        return jsonify({
            'success': True,
            'data': {
                'average_rating': round(float(avg_rating), 2),
                'total_feedback': total_feedback,
                'rating_distribution': rating_dist,
                'popular_meals': popular_meals
            }
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


# ==================== SERVE FRONTEND ====================

@app.route('/')
def index():
    """Serve the frontend HTML"""
    return render_template('index.html')


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)