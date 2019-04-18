package com.dc.members.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.dc.members.service.MemberService;
import com.dc.members.vo.MemberVo;

@Controller
public class MemberController {

	private static final Logger log = 
			LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	private MemberService memberService;
	
	//회원 전체보기
	@RequestMapping(value="/member/list.do", method=RequestMethod.GET)
	public String memberList(Model model) {
		
		log.debug("Welcome MemberController enter! ");
		
		List<MemberVo> memberList = memberService.memberSelectList();
		
		model.addAttribute("memberList", memberList);
		
		return "member/memberListView";
	}
	
	//회원한명 보기
	@RequestMapping(value = "/member/listOne.do", method=RequestMethod.GET)
	public String memberListOne(int memberNo, Model model) {
		
		log.debug("Welcome memberListOne enter! - {}", memberNo);
		
		MemberVo memberVo = memberService.memberSelectOne(memberNo);
		
		model.addAttribute("memberVo", memberVo);
		
	
	return "member/memberListOneView";
	}
	
	
	//회원 수정
	@RequestMapping(value = "/member/update.do",method = RequestMethod.GET)
	public String memberUpdate(int memberNo, Model model) {
		log.debug("Welcome memberUpdate enter! - {}", memberNo);

		MemberVo memberVo = memberService.memberSelectOne(memberNo);

		model.addAttribute("memberVo", memberVo);

		return "member/memberUpdateForm";
	}
	
	@RequestMapping(value = "/member/updateCtr.do",method = RequestMethod.POST)
	public String memberUpdateOne(HttpSession session, MemberVo memberVo,Model model) {
		log.debug("Welcome memberUpdateCtr enter! - {}", memberVo);
		
		
		try {
			 memberService.memberUpdateOne(memberVo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}


			MemberVo sessionMemberVo = (MemberVo) session.getAttribute("_memberVo_");
			
			// 세션에 객체가 존재하는지 여부
			if (sessionMemberVo != null) {
				// 세션의 값과 새로운 값이 일치하는지 여부
				// 홍길동 ㄴㅇㄹㄴㅇ
				// s1@test.com ㄴㅇㄹ33@
				// 1111 2222
				if (sessionMemberVo.getMemberNo() == memberVo.getMemberNo()) {
					MemberVo newMemberVo = new MemberVo();

					newMemberVo.setMemberNo(memberVo.getMemberNo());
					newMemberVo.setEmail(memberVo.getEmail());
					newMemberVo.setNickName(memberVo.getNickName());

					session.removeAttribute("_memberVo_");

					session.setAttribute("_memberVo_", newMemberVo);
				}
			}
			return "redirect:/member/list.do";
		}
		

	
	//회원가입
	@RequestMapping(value = "/member/add.do", method = RequestMethod.GET)
	public String memberAdd(Model model) {
		log.debug("Welcome MemberController memberAdd 페이지 이동! ");
		
		return "member/memberForm";
	}
	
	
	@RequestMapping(value = "/member/addCtr.do", method = RequestMethod.POST)
	public String memberAdd(MemberVo memberVo,  Model model) {
		log.trace("Welcome MemberController memberAdd 신규등록 처리! " + memberVo);

		try {
			memberService.memberInsertOne(memberVo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "redirect:/member/list.do";
	}
	
	
	//회원 삭제
	@RequestMapping(value = "/member/deleteCtr.do", method = RequestMethod.GET)
	public String memberDelete(int memberNo, Model model) {
		log.debug("Welcome MemberController memberDelete" + " 회원삭제 처리! - {}", memberNo);

		try {
			memberService.memberDelete(memberNo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "redirect:/member/list.do";
	}
	
	//로그인 하기
	@RequestMapping(value = "/auth/login.do", method = RequestMethod.GET)
	public String login(HttpSession session, Model model) {
		log.debug("Welcome MemberController login 페이지 이동! ");

		return "auth/loginForm";
	}
	
	@RequestMapping(value = "/auth/loginCtr.do", method = RequestMethod.POST)
	public String loginCtr(String email, String password, HttpSession session, Model model) {
		log.debug("Welcome MemberController loginCtr! -{} ,{}" + email, password);

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("email", email);
		paramMap.put("password", password);

		MemberVo memberVo = memberService.memberExist(paramMap);

		String viewUrl = "";
		if (memberVo != null) {
			// 회원이 존재한다면 세션에 담고
			// 회원 전체 조회 페이지로 이동
			session.setAttribute("_memberVo_", memberVo);

			viewUrl = "redirect:/member/list.do";
		} else {
			viewUrl = "/auth/loginFail";
		}

		return viewUrl;
	}
	
	//로그아웃하기
	@RequestMapping(value = "/auth/logout.do", method = RequestMethod.GET)
	public String logout(HttpSession session, Model model) {
		log.debug("Welcome MemberController logout 페이지 이동! ");

		// 세션의 객체들 파기
		session.invalidate();

		return "redirect:/auth/login.do";
	}

}