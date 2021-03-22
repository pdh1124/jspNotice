package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	
	private Connection conn; //데이터베이스에 접근할 수 있는 하나의 객체
	//private PreparedStatement pstmt; //여러개의 함수가 사용되기 때문에 각각 함수끼리 데이터베이스 접근에 있어서 마찰이 일어나지 않도록 try문에 옮겨줌
	private ResultSet rs; //어떠한 정보를 담을 수 있는 하나의 객체
	
	public BbsDAO() { //mySQL에 접속할 수 있게 해주는 메소드
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch(Exception e) {
			e.printStackTrace();
		}	
	}
	
	//현재의 시간을 가져오는 함수로써 게시판에 글을 작성할때 현재 서버의 시간을 넣어주는 역할을 하는 메소드
	public String getDate() { 
		String SQL = "SELECT NOW()"; //현재 시간을 가져오게 하는 MySQL의 문장
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL를 실행 준비단계로 만들어 줌
			rs = pstmt.executeQuery();//실제 실행했을때 나오는 결과를 가져온다.
			if(rs.next()) { //결과가 있는 경우
				return rs.getString(1); //현재의 날짜를 그대로 반환시켜줌
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //빈 문자열을 리턴해서 데이터베이스의 오류를 알려줌
	} 
	
	//글의 번호를 매기는 것
	public int getnext() { 
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; //마지막의 번호를 가져와서 1을 더한다.
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL를 실행 준비단계로 만들어 줌
			rs = pstmt.executeQuery();//실제 실행했을때 나오는 결과를 가져온다.
			if(rs.next()) { //결과가 있는 경우
				return rs.getInt(1) + 1; //현재의 날짜를 그대로 반환시켜줌
			}
			return 1; //첫번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //-1을 리턴해서 데이터베이스의 오류를 알려줌
	}
	
	
	//실제로 글을 작성
		public int write(String bbsTitle, String userID, String bbsContent) { 
			String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)"; //하나의 게시물을 만들어서 넣어줄 필요가 있기 때문에 6가지 인자를 다 넣는다.
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL를 실행 준비단계로 만들어 줌
				pstmt.setInt(1, getnext());
				pstmt.setString(2, bbsTitle);
				pstmt.setString(3, userID);
				pstmt.setString(4, getDate());
				pstmt.setString(5, bbsContent);
				pstmt.setInt(6, 1); //bbsAvailable이니까 1이면 삭제하지 않은 게시물, 0이면 삭제한 게시물이기 때문에 표시하기 된 게시물은 삭제되지 않는 게시물이기 때문에 1을 넣는다.
				return pstmt.executeUpdate(); //성공했다면 0이상의 결과값을 반환함
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1; //-1을 리턴해서 데이터베이스의 오류를 알려줌
		}
		
		//특정한 페이지에 따른 총10개의 게시글을 가져오는 함수를 만듦
		public ArrayList<Bbs> getList(int pageNumber) { 
			String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10"; //bbsID가 지정한 숫자(?)보다 작은때를 선정하고 삭제하지 않는 게시물을 선정 후 bbsID를 내림차순(ORDER BY)를 한 후 위에서 10개까지만 가져온다(DESC LIMIT 10) 
			ArrayList<Bbs> list = new ArrayList<Bbs>(); //Bbs에서 나온 인스턴스를 보관할수 있는 list를 만들어서 배열의 Bbs를 담음
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL를 실행 준비단계로 만들어 줌
				pstmt.setInt(1, getnext() - (pageNumber - 1) * 10); // ?에 들어갈 항목 (getnext()는 다음으로 작성될 글의 번호)
				rs = pstmt.executeQuery();
				while (rs.next()) { //결과가 나올 때마다 (반복)
					Bbs bbs = new Bbs(); //bbs라는 하나의 인스턴스를 만들어서
					bbs.setBbsID(rs.getInt(1));
					bbs.setBbsTitle(rs.getString(2));
					bbs.setUserID(rs.getString(3));
					bbs.setBbsDate(rs.getString(4));
					bbs.setBbsContent(rs.getString(5));
					bbs.setBbsAvailable(rs.getInt(6));
					list.add(bbs);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return list; //뽑아온 게시물을 리스트를 출력 
		}
		
		//다음페이지 유무
		public boolean nextPage(int pageNumber) {
			String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1"; //bbsID가 지정한 숫자(?)보다 작은때를 선정하고 삭제하지 않는 게시물을 선정
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL를 실행 준비단계로 만들어 줌
				pstmt.setInt(1, getnext() - (pageNumber - 1) * 10); // ?에 들어갈 항목 (getnext()는 다음으로 작성될 글의 번호)
				rs = pstmt.executeQuery();
				if (rs.next()) { //결과가 하나라도 존재한다면
					return true;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return false; //뽑아온 게시물을 리스트를 출력 
		}
		
		
		//글 내용을 추가하는 함수
		public Bbs getBbs(int bbsID) {
			
		}
}
