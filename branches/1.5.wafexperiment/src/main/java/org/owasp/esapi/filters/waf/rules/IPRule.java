package org.owasp.esapi.filters.waf.rules;

import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.owasp.esapi.filters.waf.internal.InterceptingHTTPServletRequest;

public class IPRule extends Rule {

	private Pattern allowedIP;
	private Pattern path;

	public IPRule(Pattern allowedIP, Pattern path) {
		this.allowedIP = allowedIP;
		this.path = path;
	}

	public boolean check(InterceptingHTTPServletRequest request,
			HttpServletResponse response) {

		System.out.println(request.getRequestURI());

		if ( path.matcher(request.getRequestURI()).matches() ) {
			if ( ! allowedIP.matcher(request.getRemoteAddr()).matches() ) {
				return false;
			}
		}

		return true;
	}

}
