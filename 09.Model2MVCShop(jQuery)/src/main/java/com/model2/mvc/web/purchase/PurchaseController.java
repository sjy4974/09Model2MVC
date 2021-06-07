package com.model2.mvc.web.purchase;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.purchase.PurchaseService;
import com.model2.mvc.service.user.UserService;

@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {
	
	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;
	
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	
	public PurchaseController() {
		// TODO Auto-generated constructor stub
		System.out.println(this.getClass());
	}
	
	@Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;
	
//	@RequestMapping("/addPurchaseView.do")
	@RequestMapping( value="addPurchase", method=RequestMethod.GET)
	public String addPurchase( @RequestParam("prodNo") int prodNo, Model model) throws Exception{
		
		System.out.println("/addPurchaseView : GET ");
		
		Product product = productService.getProduct(prodNo);
		
		model.addAttribute("product", product);
		
		return "forward:/purchase/addPurchaseView.jsp";
	}
	
//	@RequestMapping("/addPurchase.do")
	@RequestMapping( value="addPurchase", method=RequestMethod.POST)
	public String addPurchase( @ModelAttribute("purchase") Purchase purchase,
								@ModelAttribute("product") Product product,
								@ModelAttribute("user") User user,
									Model model) throws Exception{
		
		System.out.println("/addPurchase : POST");
		
		purchase.setTranCode("1");
		purchase.setBuyer(user);
		purchase.setPurchaseProd(product);
		
		purchaseService.addPurchase(purchase);
		
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/addPurchase.jsp";
	}
	
//	@RequestMapping("/getPurchase.do")
	@RequestMapping( value="getPurchase", method=RequestMethod.GET)
	public String getPurchase( @RequestParam("tranNo") int tranNo,
								Model model) throws Exception{
		
		System.out.println("/getPurchase : GET");
		
		Purchase purchase = purchaseService.getPurchase(tranNo);
		
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/getPurchase.jsp";
	}
	
//	@RequestMapping("/listPurchase.do")
	@RequestMapping( value="listPurchase")
	public String listPurchase( @ModelAttribute("search") Search search, Model model,
								 HttpSession session ) throws Exception {
		
		System.out.println("/listPurchase");
		
		if(search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		User user = (User)session.getAttribute("user");
		
		Map<String, Object> map = purchaseService.getPurchaseList(search, user.getUserId());
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		
		return "forward:/purchase/listPurchase.jsp";
	}
	
//	@RequestMapping("/updatePurchaseView.do")
	@RequestMapping( value="updatePurchase", method=RequestMethod.GET)
	public String updatePurchaseView( @RequestParam("tranNo") int tranNo, Model model) throws Exception{
		
		System.out.println("/updatePurchaseView : GET");
		
		Purchase purchase = purchaseService.getPurchase(tranNo);
		
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/updatePurchase.jsp";
	}
	
//	@RequestMapping("/updatePurchase.do")
	@RequestMapping( value="updatePurchase", method=RequestMethod.POST)
	public String updatePurchase( @ModelAttribute ("purchase") Purchase purchase) throws Exception{
		
		System.out.println("/updatePurchase : POST");
		
		purchaseService.updatePurchase(purchase);
		
		
		return "redirect:/purchase/getPurchase?tranNo="+purchase.getTranNo();
	}
	
//	@RequestMapping("/updateTranCode.do")
	@RequestMapping( value="updateTranCode", method=RequestMethod.GET)
	public String updateTranCode( @RequestParam("tranNo") int tranNo,
									@RequestParam("tranCode") String tranCode,
									@RequestParam("page") int page) throws Exception {
		
		System.out.println("/updateTranCode : GET");
		
		Purchase purchase = purchaseService.getPurchase(tranNo);

		purchase.setTranCode(tranCode);
		
		purchaseService.updateTranCode(purchase);
		
		return "redirect:/purchase/listPurchase?menu=manage&page="+page;
	}
	
//	@RequestMapping("updateTranCodeByProd.do")
	@RequestMapping( value="updateTranCodeByProd", method=RequestMethod.GET)
	public String updateTranCodeByProd( @RequestParam("prodNo") int prodNo,
											@RequestParam("tranCode") String tranCode,
											@RequestParam("page") int page) throws Exception {
		
		System.out.println("/updateTranCodeByProd : GET");
		
		Purchase purchase = purchaseService.getPurchase2(prodNo);
		
		purchase.setTranCode(tranCode);
		
		purchaseService.updateTranCode(purchase);
		
		return "redirect:/product/listProduct?menu=manage&page="+page;
		
	}

}
